require "bson"
require "active_support/core_ext/hash/keys"

module GeekGame
  module Network
    class Client < Struct.new(:socket)

      #TODO: this method is a responsibility of an another class
      def current_world_state
        game_objects = next_data_chunk["game_objects"].map(&:symbolize_keys)
        
        {}.tap do |result|
          game_objects.each do |game_object|
            id = game_object.delete(:id)
            result[id] = game_object
          end
        end
      end
      
      def next_data_chunk
        reset_buffer
        
        chunk_size = get_chunk_size
        get_data(chunk_size - 4)
        
        BSON.deserialize(buffer)
      end

      protected

      attr_accessor :buffer

      def get_chunk_size
        4.times { download_char }

        bytes = buffer.chars.map(&:ord)
        # TODO: a better way to compose an integer from bytes in Ruby?
        bytes[0] + (bytes[1] << 8) + (bytes[2] << 16) + (bytes[3] << 24)
      end

      def get_data(char_count)
        char_count.times { download_char }
      end

      def download_char
        self.buffer << socket.getc
      end

      def reset_buffer
        self.buffer = ""
      end
    end
  end
end
