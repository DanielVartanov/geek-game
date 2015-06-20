module GeekGame
  class MetalDerrick < GameObject
    define_properties :metal_bars_per_chunk, :cooldown_period
    metal_derrick_properties metal_bars_per_chunk: 5, cooldown_period: 3.0

    def initialize(position:)
      self.position = position
      self.metal_bars_available = false
      reset!
      super()
    end

    def update(seconds)
      self.seconds_passed_since_last_extraction += seconds

      extract_metal_bars! if seconds_passed_since_last_extraction >= cooldown_period
    end

    attr_reader :metal_bars_available
    alias :metal_bars_available? :metal_bars_available

    def progress
      [seconds_passed_since_last_extraction / cooldown_period, 1].min
    end

    protected

    attr_writer :metal_bars_available
    attr_accessor :seconds_passed_since_last_extraction

    def extract_metal_bars!
      self.metal_bars_available = true
    end

    def reset!
      self.seconds_passed_since_last_extraction = 0
    end
  end
end
