require "socket"
require "bson"

module GeekGame
  module Network
    class Server < Struct.new(:timeline, :host, :port)
      attr_accessor :socket

      def bind_to_port
        self.socket = TCPServer.new(host, port)
      end

      def wait_for_client
        @client = socket.accept
      end

      def push
        objects_hash = GeekGame.game_objects.to_hashes
        data_to_transmit = BSON.serialize(objects_hash).to_s

        @client.print data_to_transmit
      end
    end
  end
end
