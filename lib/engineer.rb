module GeekGame
  class Engineer < TrackedBot
    include Connectable

    tracked_bot_properties max_velocity: 70.0, axis_length: 25.0, max_health_points: 50.0, movement_cost: 0.025

    attr_reader :metal_bars_carried
    alias :metal_bars_carried? :metal_bars_carried

    def initialize(*args)
      self.metal_bars_carried = false
      super
    end

    def take_metal
      self.metal_bars_carried = true
    end

    protected

    attr_writer :metal_bars_carried
  end
end
