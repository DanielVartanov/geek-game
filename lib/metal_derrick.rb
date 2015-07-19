module GeekGame
  class MetalDerrick < Facility
    define_properties :metal_bars_per_chunk, :cooldown_period

    facility_properties connection_distance: 20
    metal_derrick_properties metal_bars_per_chunk: 5, cooldown_period: 2.0

    attr_reader :metal_bars_available
    alias :metal_bars_available? :metal_bars_available

    def initialize(position:)
      self.position = position
      reset!
      super()
    end

    def update(seconds)
      self.seconds_passed_since_last_extraction += seconds

      extract_metal_bars! if seconds_passed_since_last_extraction >= cooldown_period

      if metal_bars_available? && bots_connected? && can_give_metal_to?(connected_bots.first)
        give_metal_to! connected_bots.first
      end
    end

    def bots_connected?
      ! connections.empty?
    end

    def progress
      [seconds_passed_since_last_extraction / cooldown_period, 1].min
    end

    def to_hash
      super.tap do |hash|
        hash[:progress] = progress
        hash[:metal_bars_available] = metal_bars_available
      end
    end

    protected

    attr_writer :metal_bars_available
    attr_accessor :seconds_passed_since_last_extraction

    def can_give_metal_to?(bot)
      bot.connection.lasts_for > 0.5 || bot.connection.lasts_for === 0.5
    end

    def give_metal_to!(bot)
      bot.take_metal
      disconnect(bot)
      reset!
    end

    def extract_metal_bars!
      self.metal_bars_available = true
    end

    def reset!
      self.metal_bars_available = false
      self.seconds_passed_since_last_extraction = 0
    end
  end
end
