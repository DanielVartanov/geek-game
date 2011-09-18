# -*- coding: utf-8 -*-
module GeekGame
  class TrackedBot < GameObject
    MAX_VELOCITY = 70
    AXIS_LENGTH = 40
    SHELL_RELOAD_TIME = 2 #seconds
    MAX_HEALTH_POINTS = 1000
    MOVEMENT_COST = 0.025
    SHOOTING_COST = 0.1

    # alias :gun :gun_proxy  # <---- пушка с точки зрения TrackedBot'а (угол поворота относительно корпуса и т.д.), класс у нее TracketBot::GunProxy, у других - NNN::GunProxy
    # protected attr_reader :actual_gun

    attr_reader :left_track, :right_track
    attr_reader :gun
    attr_reader :shells
    attr_reader :health_points
    attr_reader :battery

    def track_axis
      Line(left_track_position, right_track_position)
    end

    def initialize(initial_params = {})
      self.left_track = Track.new
      self.right_track = Track.new

      self.position = initial_params[:position] || Point(0, 0)
      self.angle = initial_params[:angle] || 0
      self.player = initial_params[:player]

      self.health_points = MAX_HEALTH_POINTS
      
      self.gun = Gun.new initial_params[:gun_relative_angle] || 90.degrees

      self.last_shoot_time = Time.now - SHELL_RELOAD_TIME

      self.battery = Battery.new

      super()
    end

    def take_damage(damage_value)
      new_health_points_value = self.health_points - damage_value
      
      self.health_points = new_health_points_value > 0 ? new_health_points_value : 0

      die! if health_points.zero?
    end

    def gun_angle
      self.angle + self.gun.angle
    end

    def motor!(target_left_track_power, target_right_track_power)
      self.left_track.target_power = target_left_track_power
      self.right_track.target_power = target_right_track_power
    end

    def update(seconds)      
      left_track.update_power(seconds)
      right_track.update_power(seconds)
      stop! if battery.charge < estimated_advancing_cost(seconds)
      advance_tracks(seconds)
      discharge_battery(seconds)
      gun.update_angle(seconds)
    end

    def can_shoot?
      raise "not implemented yet"
    end

    def barrel_ending
      raise "not implemented yet"
      # barrel_ending = self.position.advance_by(unit_vector * (GUN::LENGTH)) # gun.barrel_ending
    end

    def fire!
      return unless (Time.now - self.last_shoot_time) > SHELL_RELOAD_TIME
      return if battery.charge < SHOOTING_COST

      Shell.new(:angle => self.gun_angle, :position => position, :owner => self)
      battery.discharge_by(SHOOTING_COST)

      self.last_shoot_time = Time.now
    end

    protected

    attr_writer :left_track, :right_track
    attr_writer :gun, :battery
    attr_accessor :last_shoot_time
    attr_writer :health_points

    def discharge_battery(seconds)
      battery.discharge_by(seconds * MOVEMENT_COST * left_track.power)
      battery.discharge_by(seconds * MOVEMENT_COST * right_track.power)
    end

    def estimated_advancing_cost(seconds)
      MOVEMENT_COST * seconds * (left_track.power + right_track.power)
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

    def left_track_position
      right_track_position.rotate_around(position, 180.degrees)
    end

    def right_track_position
      axis_unit_vector = Vector(1, 0).rotate(angle)
      position.advance_by(axis_unit_vector * (AXIS_LENGTH / 2))
    end  
  end
end
