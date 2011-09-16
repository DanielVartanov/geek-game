require "socket"

module GeekGame
  class NetworkServer < Struct.new(:timeline, :host, :port)
    def start!
      server = TCPServer.new(host, port)
      puts "GeekGame server is listening on #{host}:#{port}"
      client = server.accept
      loop do
        sleep(0.1)
        client.puts "ping"
      end
      
=begin      
      loop do
        Thread.start(server.accept) do |client|
          loop do
            sleep(0.1)
            client.puts "ping"
          end
        end
      end
=end
    end
  end
end
