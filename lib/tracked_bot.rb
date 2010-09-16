# -*- coding: utf-8 -*-
class TrackedBot
  MAX_VELOCITY = 70
  AXIS_LENGTH = 40

  attr_reader :position, :angle
  attr_reader :left_track, :right_track

  def track_axis
    Line(left_track.position, right_track.position)
  end

  def initialize
    self.left_track = Track.new(self)
    self.right_track = Track.new(self)

    self.position = Point(0, 0)
    self.angle = 90.degrees
  end

  def update(seconds)
    [left_track, right_track].each { |track| track.update_power(seconds) }
    
    move_tracks(seconds)
  end

  def draw(surface)
    Graphics::TrackedBot.new(self, surface).draw
  end

protected

  attr_writer :position, :angle
  attr_writer :left_track, :right_track
end

class Track < Struct.new(:tracked_bot)
  TRACK_POWER_ACCELERATION = 0.7

  attr_reader :power
  attr_accessor :target_power

  def initialize(tracked_bot)
    self.power = 0
    super(tracked_bot)
  end

  def update_power(seconds)
    power_diff = target_power - power

    if power_diff.abs < TRACK_POWER_ACCELERATION * seconds
      self.power = target_power
    else
      self.power += TRACK_POWER_ACCELERATION * seconds * power_diff.sign
    end    
  end

protected

  attr_writer :power
end
