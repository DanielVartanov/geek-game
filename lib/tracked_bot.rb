# -*- coding: utf-8 -*-
module GeekGame
  class TrackedBot < GameObject
    MAX_VELOCITY = 70
    AXIS_LENGTH = 40
    SHELL_RELOAD_TIME = 2
    MAX_HEALTH_POINTS = 1000

    # alias :gun :gun_proxy
    # protected attr_reader :actual_gun

    attr_reader :position, :angle
    attr_reader :left_track, :right_track
    attr_reader :gun
    attr_reader :shells
    attr_reader :health_points

    def track_axis
      Line(left_track_position, right_track_position)
    end

    def initialize(initial_params = {})
      self.left_track = Track.new
      self.right_track = Track.new

      self.position = initial_params[:position] || Point(0, 0)
      self.angle = initial_params[:angle] || 0

      self.health_points = MAX_HEALTH_POINTS
      
      self.gun = Gun.new initial_params[:gun_relative_angle] || 90.degrees
      self.shells = []

      super()
    end

    def take_damage(damage_value)
      new_health_points_value = self.health_points - damage_value
      
      self.health_points = new_health_points_value > 0 ? new_health_points_value : 0
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

      shells.each do |shell|
        if shell.died?
          shells.delete_at shells.index(shell)
          next
        end

        shell.update_position(time_step)
      end
    end

    def fire!
      return if last_shoot_time && (Time.now.to_f - self.last_shoot_time) < SHELL_RELOAD_TIME
      
      target_angle = self.gun_angle
      axis_unit_vector = Vector(1, 0).rotate(target_angle)
      start_pos = self.position.advance_by(axis_unit_vector * (AXIS_LENGTH/2))
      
      self.shells << Shell.new(:target_angle => target_angle, :position => start_pos)

      self.last_shoot_time = Time.now.to_f
    end

    def draw(surface)
      Graphics::TrackedBot.new(self, surface).draw
    end

    protected

    attr_writer :position, :angle
    attr_writer :left_track, :right_track
    attr_writer :gun
    attr_writer :shells
    attr_accessor :last_shoot_time
    attr_writer :health_points

    def left_track_position
      right_track_position.rotate_around(position, 180.degrees)
    end

    def right_track_position
      axis_unit_vector = Vector(1, 0).rotate(angle)
      position.advance_by(axis_unit_vector * (AXIS_LENGTH / 2))
    end  
  end
end
