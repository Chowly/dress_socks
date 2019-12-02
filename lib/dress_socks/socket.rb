module DressSocks
  class Socket < ::TCPSocket
    attr_accessor :socks_server, :socks_port, :socks_version, :socks_ignores, :socks_username, :socks_password
  
    alias :initialize_tcp :initialize
  

    def encoded_socks_version
      (self.socks_version == "4a" or self.socks_version == "4") ? "\004" : "\005"
    end

    # See http://tools.ietf.org/html/rfc1928
    def initialize(remote_host=nil, remote_port=0, local_host=nil, local_port=nil, 
                   socks_username: nil, socks_password: nil, socks_server: nil, socks_port: nil, 
                   socks_ignores: [], socks_version: '5')

      self.socks_server = socks_server
      self.socks_port = socks_port
      self.socks_username = socks_username
      self.socks_password = socks_password
      self.socks_ignores = socks_ignores
      self.socks_version = socks_version


      if socks_server and socks_port and not socks_ignores.include?(remote_host)
        initialize_tcp socks_server, socks_port
  
        socks_authenticate unless socks_version =~ /^4/
  
        if remote_host
          socks_connect(remote_host, remote_port)
        end
      else
        initialize_tcp remote_host, remote_port, local_host, local_port
      end
    end
  
    # Authentication
    def socks_authenticate
      if self.socks_username || self.socks_password
                write "\005\001\002"
      else
                write "\005\001\000"
      end
      auth_reply = recv(2)
      if auth_reply.empty?
        raise DressSocks::SOCKSError.new("Server doesn't reply authentication")
      end
      if auth_reply[0..0] != "\004" and auth_reply[0..0] != "\005"
        raise DressSocks::SOCKSError.new("SOCKS version #{auth_reply[0..0]} not supported")
      end
      if self.socks_username || self.socks_password
        if auth_reply[1..1] != "\002"
          raise DressSocks::SOCKSError.new("SOCKS authentication method #{auth_reply[1..1]} neither requested nor supported")
        end
        auth = "\001"
        auth += self.socks_username.to_s.length.chr
        auth += self.socks_username.to_s
        auth += self.socks_password.to_s.length.chr
        auth += self.socks_password.to_s
        write auth
        auth_reply = recv(2)
        if auth_reply[1..1] != "\000"
          raise DressSocks::SOCKSError.new("SOCKS authentication failed")
        end
      else
        if auth_reply[1..1] != "\000"
          raise DressSocks::SOCKSError.new("SOCKS authentication method #{auth_reply[1..1]} neither requested nor supported")
        end
      end
    end
  
    # Connect
    def socks_connect(host, port)
      port = ::Socket.getservbyname(port) if port.is_a?(String)
      req = String.new
      req << self.encoded_socks_version
      req << "\001"
      req << "\000" if self.socks_version == "5"
      req << [port].pack('n') if self.socks_version =~ /^4/
  
      if self.socks_version == "4"
        host = Resolv::DNS.new.getaddress(host).to_s
      end
      if host =~ /^(\d+)\.(\d+)\.(\d+)\.(\d+)$/  # to IPv4 address
        req << "\001" if self.socks_version == "5"
        _ip = [$1.to_i,
               $2.to_i,
               $3.to_i,
               $4.to_i
              ].pack('CCCC')
        req << _ip
      elsif host =~ /^[:0-9a-f]+$/  # to IPv6 address
        raise "TCP/IPv6 over SOCKS is not yet supported (inet_pton missing in Ruby & not supported by Tor"
        req << "\004"
      else                          # to hostname
        if self.socks_version == "5"
          req << "\003" + [host.size].pack('C') + host
        else
          req << "\000\000\000\001"
          req << "\007\000"
          req << host
          req << "\000"
        end
      end
      req << [port].pack('n') if self.socks_version == "5"

      write req
  
      socks_receive_reply
    end
  
    # returns [bind_addr: String, bind_port: Fixnum]
    def socks_receive_reply
      if self.socks_version == "5"
        connect_reply = recv(4)
        if connect_reply.empty?
          raise DressSocks::SOCKSError.new("Server doesn't reply")
        end
        if connect_reply[0..0] != "\005"
          raise DressSocks::SOCKSError.new("SOCKS version #{connect_reply[0..0]} is not 5")
        end
        if connect_reply[1..1] != "\000"
          raise DressSocks::SOCKSError.for_response_code(connect_reply.bytes.to_a[1])
        end
        bind_addr_len = case connect_reply[3..3]
                when "\001"
                  4
                when "\003"
                  recv(1).bytes.first
                when "\004"
                  16
                else
                  raise DressSocks::SOCKSError.for_response_code(connect_reply.bytes.to_a[3])
                end
        bind_addr_s = recv(bind_addr_len)
        bind_addr = case connect_reply[3..3]
                    when "\001"
                      bind_addr_s.bytes.to_a.join('.')
                    when "\003"
                      bind_addr_s
                    when "\004"  # Untested!
                      i = 0
                      ip6 = ""
                      bind_addr_s.each_byte do |b|
                        if i > 0 and i % 2 == 0
                          ip6 += ":"
                        end
                        i += 1
  
                        ip6 += b.to_s(16).rjust(2, '0')
                      end
                    end
        bind_port = recv(bind_addr_len + 2)
        [bind_addr, bind_port.unpack('n')]
      else
        connect_reply = recv(8)
        unless connect_reply[0] == "\000" and connect_reply[1] == "\x5A"
          raise DressSocks::SOCKSError.new("Failed while connecting througth socks")
        end
      end
    end
  end
end