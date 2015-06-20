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
      if seconds_passed_since_last_extraction >= cooldown_period
        self.metal_bars_available = true
        reset!
      end
    end

    attr_reader :metal_bars_available
    alias :metal_bars_available? :metal_bars_available

    protected

    attr_writer :metal_bars_available
    attr_accessor :seconds_passed_since_last_extraction

    def reset!
      self.seconds_passed_since_last_extraction = 0
    end
  end
end
