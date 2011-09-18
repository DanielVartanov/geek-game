module GeekGame
  module Network
    class Client < Struct.new(:socket)
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
