class TrackedBot
  TRACK_POWER_ACCELERATION = 0.7
  TRACK_MAX_VELOCITY = 70
  
  attr_accessor :left_track, :right_track  
  
  # Tracks model
  
  attr_accessor :left_track_power, :right_track_power
  attr_accessor :target_left_track_power, :target_right_track_power
  
  attr_accessor :intersection_point
  
  def angle
    x_axis = Vector(1, 0)
    x_axis.angle_with(Vector.by_end_points(left_track, right_track))
  end
  
  def position
    Segment(left_track, right_track).middle_point
  end
  
  def axis_lenghth
    40
  end
  
  def track_axis
    Line(left_track, right_track)
  end

  def move_tracks(seconds)
    # current_velocity = TRACK_MAX_VELOCITY * track_power
    left_track_delta = Vector(0, seconds * TRACK_MAX_VELOCITY * left_track_power).rotate(angle)
    right_track_delta = Vector(0, seconds * TRACK_MAX_VELOCITY * right_track_power).rotate(angle)

    advanced_left_track = (left_track.to_radius + left_track_delta).to_point
    advanced_right_track = (right_track.to_radius + right_track_delta).to_point
    
    if (left_track_power - right_track_power).abs <= Float::EPSILON * 2
      self.left_track = advanced_left_track
      self.right_track = advanced_right_track
    else
      advanced_track_axis = Line(advanced_left_track, advanced_right_track)

      angle_delta = track_axis.angle_with(advanced_track_axis)
      self.intersection_point = track_axis.intersection_point_with(advanced_track_axis)

      self.left_track = left_track.rotate_around(intersection_point, angle_delta)
      self.right_track = right_track.rotate_around(intersection_point, angle_delta)
    end
  end
  
  def initialize
    @left_track = Point(-20, 0)
    @right_track = Point(20, 0)
    
    @left_track_power = 0
    @right_track_power = 0

    @target_left_track_power = -1.0
    @target_right_track_power = 1.0
  end

  def update(milliseconds)
    seconds = milliseconds * 1e-3    
    unless left_track_power === target_left_track_power
      diff = target_left_track_power - left_track_power
      if diff <= TRACK_POWER_ACCELERATION * seconds
        self.left_track_power += diff
      else
        diff_sign = diff <=> 0.0
        self.left_track_power += TRACK_POWER_ACCELERATION * seconds * diff_sign
      end      
    end

    unless right_track_power === target_right_track_power
      diff = target_right_track_power - right_track_power
      if diff <= TRACK_POWER_ACCELERATION * seconds
        self.right_track_power += diff
      else
        diff_sign = diff <=> 0.0
        self.right_track_power += TRACK_POWER_ACCELERATION * seconds * diff_sign
      end      
    end

    move_tracks(seconds)
  end

  def draw(surface)
    Graphics::TrackedBot.new(self, surface).draw
  end  
end
