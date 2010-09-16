# -*- coding: utf-8 -*-
class TrackedBot
  MAX_VELOCITY = 70
  AXIS_LENGTH = 40

  attr_reader :position, :angle
  attr_reader :left_track, :right_track

  def track_axis
    Line(left_track_position, right_track_position)
  end

  def initialize
    self.left_track = Track.new(self)
    self.right_track = Track.new(self)

    self.position = Point(0, 0)
    self.angle = 90.degrees
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
      left_track.update_power(seconds)
      right_track.update_power(seconds)
      advance_tracks(time_step)
    end
  end

  def draw(surface)
    Graphics::TrackedBot.new(self, surface).draw
  end

  protected

  attr_writer :position, :angle
  attr_writer :left_track, :right_track

  def left_track_position
    right_track_position.rotate_around(position, 180.degrees)
  end

  def right_track_position
    axis_unit_vector = Vector(1, 0).rotate(angle)
    position.advance_by(axis_unit_vector * (AXIS_LENGTH / 2))
  end  
end

class Track < Struct.new(:tracked_bot)
  TRACK_POWER_ACCELERATION = 0.7

  attr_reader :power
  attr_accessor :target_power

  def initialize(tracked_bot)
    self.power = 0
    self.target_power = 0
    super(tracked_bot)
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
