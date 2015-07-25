module GeekGame
  class Engineer < TrackedBot
    include Connectable

    tracked_bot_properties max_velocity: 140.0, axis_length: 25.0, max_health_points: 50.0, movement_cost: 0.005, track_class: EngineerTrack

    attr_reader :metal_bars_carried
    alias :metal_bars_carried? :metal_bars_carried

    def initialize(*args)
      self.metal_bars_carried = false
      super
    end

    def take_metal
      self.metal_bars_carried = true
    end

    def update(seconds)
      super

      if connected_to_facility? && connection_warmed_up?
        handle_connection
      end
    end

    def to_hash
      super.tap do |base_hash|
        base_hash[:metal_bars_carried] = metal_bars_carried
      end
    end

    protected

    attr_writer :metal_bars_carried

    def connection_warmed_up?
      connection.lasts_for > 0.5 || connection.lasts_for === 0.5
    end

    def handle_connection
      if connected_facility.is_a?(Factory)
        if metal_bars_carried?
          self.metal_bars_carried = false
          connected_facility.receive_metal_bars(5)
        end
        connection.close
      end
    end
  end
end
