module GeekGame
  class Factory < Facility
    define_properties :production_time, :bot_class, :production_cost
    attr_reader :position, :angle, :production_lasts_for, :player, :metal_bars_count, :producing
    alias :producing? :producing

    def initialize(options)
      self.position = options[:position]
      self.angle = options[:angle]
      self.player = options[:player]
      self.metal_bars_count = 0
      self.producing = false

      super()
    end

    def update(seconds)
      if ! producing? && metal_bars_count >= production_cost
        start_production!
      end

      if producing?
        self.production_lasts_for += seconds
      end

      if producing? && production_time_passed?
        finish_production!
      end
    end

    def orientation
      Vector.polar(1, angle)
    end

    def progress
      producing? ?
        production_lasts_for / production_time :
        0
    end

    def production_time_passed?
      production_lasts_for > production_time || production_lasts_for === production_time
    end

    def receive_metal_bars(count)
      self.metal_bars_count += count
    end

    protected

    def start_production!
      self.metal_bars_count -= production_cost
      self.production_lasts_for = 0
      self.producing = true
    end

    def finish_production!
      create_bot
      self.producing = false
    end

    def create_bot
      bot_class.new position: position.advance_by(orientation * 25),
        angle: angle,
        player: player
    end

    attr_writer :position, :angle, :production_lasts_for, :player, :metal_bars_count, :producing
  end
end
