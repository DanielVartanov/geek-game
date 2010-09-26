module GeekGame
  class Shell < GameObject
    VELOCITY = 240
    MAX_RANGE = 400
    MAX_DAMAGE_VALUE = 300

    attr_reader :target_angle
    attr_reader :position
    attr_reader :damage_value
    attr_reqder :owner
    
    def initialize(initial_options)
      self.died = false
      self.target_angle = initial_options[:target_angle] || 0
      self.position = initial_options[:position] || Point(0, 0)
      self.damage_value = MAX_DAMAGE_VALUE
      self.owner = initial_options[:owner]
      self.initial_position = self.position

      super()
    end

    def update(seconds)
      velocity_vector = Vector(1, 0).rotate(target_angle) * (VELOCITY * seconds)

      next_position = self.position.advance_by(velocity_vector)

      if next_position.distance_to(self.initial_position) > MAX_RANGE
        next_position = self.initial_position.advance_by(Vector(1, 0).rotate(self.target_angle) * MAX_RANGE)
        die!
      end

      self.position = next_position
    end

    def died?
      self.died
    end

    def die!
      #Yes, sir :-)
      self.died = true
    end

    protected

    attr_writer :target_angle
    attr_writer :position
    attr_writer :damage_value
    attr_writer :owner
    attr_accessor :initial_position
    attr_accessor :died
  end
end
