module GeekGame
  class Track
    TRACK_POWER_ACCELERATION = 0.7

    attr_reader :power, :bot
    attr_accessor :target_power

    def initialize(bot)
      self.bot = bot
      self.power = 0
      self.target_power = 0
    end

    def update_power(seconds)
      power_diff = target_power - power

      if power_diff.abs < TRACK_POWER_ACCELERATION * seconds
        self.power = target_power
      else
        self.power += TRACK_POWER_ACCELERATION * seconds * power_diff.sign
      end
    end

    def to_hash
      { :power => power, :position => position.to_array }
    end

    protected

    attr_writer :power, :bot
  end
end
