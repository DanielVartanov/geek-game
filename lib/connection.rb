module GeekGame
  class Connection < GameObject
    attr_reader :bot, :facility, :lasts_for

    def initialize(bot:, facility:)
      super()

      self.bot = bot
      self.facility = facility
      self.lasts_for = 0

      bot.connection_established(self)
      facility.connection_established(self)
    end

    def update(seconds)
      self.lasts_for += seconds
      close unless bot.can_connect_to?(facility)
    end

    def close
      bot.connection_closed
      facility.connection_closed(self)
      deregister!
    end

    protected

    attr_writer :bot, :facility, :lasts_for
  end
end
