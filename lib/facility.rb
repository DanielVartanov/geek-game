module GeekGame
  class Facility < GameObject
    attr_reader :connections

    def initialize(*args)
      self.connections = []
      super
    end

    def accept_connection(connection)
      connections << connection
    end

    def connected_bots
      connections.map(&:bot)
    end

    protected

    attr_writer :connections
  end
end
