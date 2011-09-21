module GeekGame
  class Gun
    #alias :relative_angle :angle

    attr_reader :bot
    
    def initialize(bot, initial_angle = 90.degrees)
      self.bot = bot
      self.current_vector = Vector(1, 0).rotate(initial_angle)
      self.target_vector = self.current_vector
    end

    def update_angle(seconds)
      angle_diff = self.current_vector.signed_angle_with(self.target_vector)

      if angle_diff.abs < ANGULAR_VELOCITY * seconds
        self.current_vector = self.current_vector.rotate(angle_diff)
      else
        self.current_vector = self.current_vector.rotate(ANGULAR_VELOCITY * seconds * angle_diff.sign)
      end
    end

    def rotate(angle)
      self.target_vector = self.current_vector.rotate(angle)
    end

    def vector
      self.current_vector
    end

    def angle
      Vector(1,0).signed_angle_with(self.vector)
    end

    def absolute_angle
      bot.angle + self.angle
    end
    
    protected

    ANGULAR_VELOCITY = 360.degrees

    attr_accessor :current_vector
    attr_accessor :target_vector

    attr_writer :bot
  end
end
