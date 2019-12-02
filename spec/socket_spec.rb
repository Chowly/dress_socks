RSpec.describe DressSocks::Socket do

  context 'connects via socket' do
    let(:socket) { DressSocks::Socket.new('socktest.ngrok.io', 80, socks_server: '104.209.187.64', socks_port: 1080, socks_username: 'socksuser', socks_password: '8ewsVnpBfm8FDjcYdpkjFyG2') }

    it 'should get data' do
      socket.write("GET /users/sign_in HTTP/1.1\r\nHost: socktest.ngrok.io\r\nConnection: close\r\nUser-Agent: Test\r\n\r\n\r\n")
    end

  end

end
