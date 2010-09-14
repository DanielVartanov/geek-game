class TrackedBot
  attr_accessor :left_track, :right_track  
  
  # Tracks model
  
  attr_accessor :left_track_power, :right_track_power
  
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

  def move_tracks(distance)
    left_track_delta = Vector(0, distance * left_track_power).rotate(angle)
    right_track_delta = Vector(0, distance * right_track_power).rotate(angle)

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
  
  # Drawing      

  def draw_track(surface, center, size)
    side_length = size.to_f
    corners = [Point(center.x - side_length / 2, center.y - side_length / 2),
               Point(center.x + side_length / 2, center.y - side_length / 2),
               Point(center.x + side_length / 2, center.y + side_length / 2),
               Point(center.x - side_length / 2, center.y + side_length / 2)]
    corners.map! { |point| point.rotate_around(center, angle) }
    color = (size > 0) ? surface.default_color : [0xff, 0x00, 0x00]
    surface.rectangle(corners, color)
  end

  def draw(surface)
    surface.line(track_axis)
    
    surface.triangle(Point(position.x - 3, position.y).rotate_around(position, angle),
                     Point(position.x, position.y + 5.2).rotate_around(position, angle),
                     Point(position.x + 3, position.y).rotate_around(position, angle))

    draw_track(surface, left_track, 8 * left_track_power)
    draw_track(surface, right_track, 8 * right_track_power)
  end
  
  def initialize
    @left_track = Point(-20, 0)
    @right_track = Point(20, 0)
    
    @left_track_power = -0.1
    @right_track_power = 1
  end
end
