module GeekGame
  class Facility < GameObject
    attr_reader :connections

    def initialize(*args)
      self.connections = []
      super
    end

    def connected_bots
      connections.map(&:bot)
    end

    def disconnect(bot)
      bot.connection.close
    end

    # This method is to be called only by Connection
    def connection_established(connection)
      connections << connection
    end

    # This method is to be called only by Connection
    def connection_closed(connection)
      connections.delete connection
    end

    protected

    attr_writer :connections
  end
end
