module GeekGame
  class NetworkServer
    def start!
      server = TCPServer.new(game_server, 'localhost', 21000)
      puts "Waiting for client"
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
