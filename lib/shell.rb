module GeekGame
  class Shell < GameObject
    VELOCITY = 200
    MAX_RANGE = 400
    MAX_DAMAGE = 80

    attr_reader :owner, :angle

    def initialize(params={})
      self.angle = params[:angle] || 0
      self.position = self.initial_position = params[:position] || Point(0, 0)
      self.owner = params[:owner]

      super()
    end

    def flight_range
      initial_position.distance_to(position)
    end

    def max_range_reached?
      flight_range > MAX_RANGE
    end

    def velocity_vector
      Vector(1, 0).rotate(angle) * (VELOCITY)
    end

    def update(seconds)
      next_position = position.advance_by(velocity_vector * seconds)
      self.position = next_position

      die! if max_range_reached?
    end

    def damage
      MAX_DAMAGE
    end

    def hit?(bot)
      position.distance_to(bot.position) <= bot.axis_length.to_f / 2
    end

    protected

    attr_writer :owner, :angle
    attr_accessor :initial_position
  end
end
