module GeekGame
  class TrackedBot < GameObject
    define_properties :max_velocity, :axis_length, :max_health_points, :movement_cost, :track_class

    attr_reader :left_track, :right_track
    attr_reader :health_points
    attr_reader :battery
    attr_reader :player
    attr_reader :angle
    attr_reader :position

    def track_axis
      Line(left_track_position, right_track_position)
    end

    def initialize(initial_params = {})
      self.left_track = track_class.new
      self.right_track = track_class.new

      self.position = initial_params[:position] || Point(0, 0)
      self.angle = (initial_params[:angle] || 0) - 90.degrees
      self.player = initial_params[:player]

      self.health_points = max_health_points

      self.battery = Battery.new

      super()
    end

    def take_damage(damage_value)
      self.health_points = [0, health_points - damage_value].max
      die! if health_points.zero?
    end

    def motor!(target_left_track_power, target_right_track_power)
      self.left_track.target_power = target_left_track_power
      self.right_track.target_power = target_right_track_power
    end

    def update(seconds)
      left_track.update_power(seconds)
      right_track.update_power(seconds)
      stop! if battery.charge < advancing_cost(seconds)
      advance_tracks(seconds)
    end

    def to_hash
      super.tap do |base_hash|
        base_hash[:health_points] = health_points
        base_hash[:battery] = battery.to_hash
        base_hash[:left_track_position_coordinates] = left_track_position.to_array
        base_hash[:right_track_position_coordinates] = right_track_position.to_array
        base_hash[:left_track_power] = left_track.power
        base_hash[:right_track_power] = right_track.power
      end
    end

    def left_track_position
      right_track_position.rotate_around(position, 180.degrees)
    end

    def right_track_position
      position.advance_by(normalized_axis_vector * (axis_length / 2))
    end

    def normalized_movement_vector
      normalized_axis_vector.rotate(90.degrees)
    end

    def normalized_axis_vector
      Vector(1, 0).rotate(angle)
    end

    protected

    attr_writer :left_track, :right_track
    attr_writer :battery
    attr_writer :health_points
    attr_writer :player
    attr_writer :angle
    attr_writer :position

    def advancing_cost(seconds)
      movement_cost * seconds * (left_track.power + right_track.power)
    end

    def advance_tracks(seconds)
      left_track_movement_vector = normalized_movement_vector * max_velocity * seconds * left_track.power
      right_track_movement_vector = normalized_movement_vector * max_velocity * seconds * right_track.power

      advanced_left_track_position = left_track_position.advance_by(left_track_movement_vector)
      advanced_right_track_position = right_track_position.advance_by(right_track_movement_vector)

      track_axis_vector = Vector.by_end_points(left_track_position, right_track_position)
      advanced_track_axis_vector = Vector.by_end_points(advanced_left_track_position, advanced_right_track_position)
      advanced_track_axis = Line(advanced_left_track_position, advanced_right_track_position)

      angle_diff = track_axis_vector.signed_angle_with(advanced_track_axis_vector)

      if angle_diff.abs <= 1E-7
        movement_vector = normalized_movement_vector * max_velocity * left_track.power * seconds
        self.position = position.advance_by(movement_vector)
      else
        intersection_point = track_axis.intersection_point_with(advanced_track_axis)
        self.angle += angle_diff
        self.position = position.rotate_around(intersection_point, angle_diff)
      end

      battery.discharge_by advancing_cost(seconds)
    end
  end
end
