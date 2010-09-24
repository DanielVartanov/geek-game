# -*- coding: utf-8 -*-
class TrackedBot
  MAX_VELOCITY = 70
  AXIS_LENGTH = 40

  # alias :gun :gun_proxy
  # protected attr_reader :actual_gun

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
    left_track.update_power(seconds)
    right_track.update_power(seconds)
    advance_tracks(seconds)
    gun.update_angle(seconds)
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
