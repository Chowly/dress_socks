module DressSocks
  class SOCKSError < RuntimeError
    def initialize(msg = nil)
      super
    end

    class ServerFailure < SOCKSError
      def initialize
        super("general SOCKS server failure")
      end
    end
    class NotAllowed < SOCKSError
      def initialize
        super("connection not allowed by ruleset")
      end
    end
    class NetworkUnreachable < SOCKSError
      def initialize
        super("Network unreachable")
      end
    end
    class HostUnreachable < SOCKSError
      def initialize
        super("Host unreachable")
      end
    end
    class ConnectionRefused < SOCKSError
      def initialize
        super("Connection refused")
      end
    end
    class TTLExpired < SOCKSError
      def initialize
        super("TTL expired")
      end
    end
    class CommandNotSupported < SOCKSError
      def initialize
        super("Command not supported")
      end
    end
    class AddressTypeNotSupported < SOCKSError
      def initialize
        super("Address type not supported")
      end
    end

    def self.for_response_code(code)
      case code
      when 1
        ServerFailure
      when 2
        NotAllowed
      when 3
        NetworkUnreachable
      when 4
        HostUnreachable
      when 5
        ConnectionRefused
      when 6
        TTLExpired
      when 7
        CommandNotSupported
      when 8
        AddressTypeNotSupported
      else
        self
      end
    end
  end
end
