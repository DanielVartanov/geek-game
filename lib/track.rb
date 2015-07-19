module GeekGame
  class Track
    attr_reader :power
    attr_accessor :target_power

    def initialize
      self.power = 0
      self.target_power = 0
    end

    def update_power(seconds)
      power_diff = target_power - power

      if power_diff.abs < self.class.power_acceleration * seconds
        self.power = target_power
      else
        self.power += self.class.power_acceleration * seconds * power_diff.sign
      end
    end

    protected

    attr_writer :power
  end
end
