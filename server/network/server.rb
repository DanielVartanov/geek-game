require "socket"
require "bson"

module GeekGame
  class NetworkServer < Struct.new(:timeline, :host, :port)
    def start!
      bind_to_port
      puts "GeekGame server is listening on #{host}:#{port}"
      
      main_loop
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

    protected

    attr_accessor :socket

    def bind_to_port
      self.socket = TCPServer.new(host, port)
    end

    def main_loop
      client = socket.accept
      puts "Client connected"

      loop do
        sleep(0.1) # do not convert to Rubygame::clock or whatever takes CPU quants
        objects_hash = GeekGame.game_objects.to_hashes
        data_to_transmit = BSON.serialize(objects_hash).to_s
        client.puts data_to_transmit
        
        # TODO: add put_byte_array to ruby sockets
      end
    end
  end
end
