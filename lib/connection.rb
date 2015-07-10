module GeekGame
  class Connection < GameObject
    attr_reader :bot, :facility

    def initialize(bot:, facility:)
      self.bot = bot
      self.facility = facility

      bot.accept_connection(self)
      facility.accept_connection(self)
    end

    def update(_)

    end

    def close
      bot.remove_connection
      facility.remove_connection(self)
    end

    protected

    attr_writer :bot, :facility
  end
end
