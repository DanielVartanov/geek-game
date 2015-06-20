module GeekGame
  class MetalDerrick < GameObject
    define_properties :metal_bars_per_chunk, :cooldown_period
    metal_derrick_properties metal_bars_per_chunk: 5, cooldown_period: 3.0

    def initialize(position:)
      self.position = position
      super()
    end

    def update(seconds)

    end
  end
end
