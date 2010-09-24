class Shell
  VELOCITY = 210

  attr_reader :target_angle
  attr_reader :position
  
  def initialize(initial_options)
    self.target_angle = initial_options[:target_angle] || 0
    self.position = initial_options[:position] || Point(0, 0)
  end

  def update_position(seconds)
    velocity_vector = Vector(1, 0).rotate(target_angle) * (VELOCITY * seconds)

    self.position = self.position.advance_by(velocity_vector)
  end

  protected

  attr_writer :target_angle
  attr_writer :position
end
