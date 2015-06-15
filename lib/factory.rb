module GeekGame
  class Factory < GameObject
    define_properties :production_time, :bot_class
    factory_properties production_time: 5.0, bot_class: PewPew

    attr_reader :position, :angle, :production_start_time

    def initialize(options)
      self.position = options[:position]
      self.angle = options[:angle]
      self.player = options[:player]
      self.production_start_time = Time.now

      super()
    end

    def update(seconds)
      if production_time_passed?
        create_bot
        self.production_start_time = Time.now
      end
    end

    def orientation
      Vector.polar(1, angle)
    end

    def progress
      (Time.now - production_start_time) / production_time
    end

    def production_time_passed?
      Time.now - production_start_time > production_time
    end

    protected

    def create_bot
      bot_class.new position: position.advance_by(orientation * 25),
        angle: angle - 90.degrees,
        player: player
    end

    attr_writer :position, :angle, :production_start_time
  end
end
