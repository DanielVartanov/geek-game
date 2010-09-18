# -*- coding: utf-8 -*-
class TrackedBot
  MAX_VELOCITY = 70
  AXIS_LENGTH = 40

  attr_reader :position, :angle
  attr_reader :left_track, :right_track
  attr_reader :gun

  def track_axis
    Line(left_track_position, right_track_position)
  end

  def initialize(initial_params = {})
    self.left_track = Track.new
    self.right_track = Track.new

    self.position = initial_params[:position] || Point(0, 0)
    self.angle = initial_params[:angle] || 0

    self.gun = Gun.new initial_params[:gun_relative_angle] || 90.degrees
  end

  def gun_angle
    self.angle + self.gun.angle
  end

  def motor!(target_left_track_power, target_right_track_power)
    self.left_track.target_power = target_left_track_power
    self.right_track.target_power = target_right_track_power
  end  

  def advance_tracks(seconds)
    movement_unit_vector = Vector(1, 0).rotate(angle).rotate(90.degrees)
    left_track_movement_vector = movement_unit_vector * MAX_VELOCITY * seconds * left_track.power
    right_track_movement_vector = movement_unit_vector * MAX_VELOCITY * seconds * right_track.power

    advanced_left_track_position = left_track_position.advance_by(left_track_movement_vector)
    advanced_right_track_position = right_track_position.advance_by(right_track_movement_vector)

    track_axis_vector = Vector.by_end_points(left_track_position, right_track_position)
    advanced_track_axis_vector = Vector.by_end_points(advanced_left_track_position, advanced_right_track_position)
    advanced_track_axis = Line(advanced_left_track_position, advanced_right_track_position)

    angle_diff = track_axis_vector.signed_angle_with(advanced_track_axis_vector)

    if angle_diff.zero?
      movement_vector = movement_unit_vector * MAX_VELOCITY * left_track.power * seconds
      self.position = position.advance_by(movement_vector)
    else
      intersection_point = track_axis.intersection_point_with(advanced_track_axis)
      self.angle += angle_diff
      self.position = position.rotate_around(intersection_point, angle_diff)
    end
  end

  def update(seconds)
    time_step = 1e-3

    (seconds.to_f / time_step).to_i.times do
      left_track.update_power(time_step)
      right_track.update_power(time_step)
      advance_tracks(time_step)
      gun.update_angle(time_step)
    end
  end

  def draw(surface)
    Graphics::TrackedBot.new(self, surface).draw
  end

  protected

  attr_writer :position, :angle
  attr_writer :left_track, :right_track
  attr_writer :gun

  def left_track_position
    right_track_position.rotate_around(position, 180.degrees)
  end

  def right_track_position
    axis_unit_vector = Vector(1, 0).rotate(angle)
    position.advance_by(axis_unit_vector * (AXIS_LENGTH / 2))
  end  
end

class Track
  TRACK_POWER_ACCELERATION = 0.7

  attr_reader :power
  attr_accessor :target_power

  def initialize
    self.power = 0
    self.target_power = 0
  end

  def update_power(seconds)
    power_diff = target_power - power

    # self.power = [upper_bound, TRACK_POWER_ACCELERATION * seconds * power_diff.sign].min

    if power_diff.abs < TRACK_POWER_ACCELERATION * seconds
      self.power = target_power
    else
      self.power += TRACK_POWER_ACCELERATION * seconds * power_diff.sign
    end    
  end

  protected

  attr_writer :power
end

class Gun
  #alias :relative_angle :angle
  
  def initialize(initial_angle = 90.degrees)
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
  
  protected

  ANGULAR_VELOCITY = 3

  attr_accessor :current_vector
  attr_accessor :target_vector
end

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
