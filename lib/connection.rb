module GeekGame
  class Connection < GameObject
    attr_reader :bot, :facility

    def initialize(bot:, facility:)
      self.bot = bot
      self.facility = facility

      bot.connection_established(self)
      facility.connection_established(self)
    end

    def update(_)
      close unless bot.can_connect_to?(facility)
    end

    def close
      bot.connection_closed
      facility.connection_closed(self)
    end

    protected

    attr_writer :bot, :facility
  end
end
