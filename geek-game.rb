# -*- coding: utf-8 -*-
require 'rubygems'
require 'gosu'

require 'geometry/init'

class Point
  def to_screen
    Point(320 + x, 240 - y)
  end
end

class Player
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
  
  def draw_track(center, size)
    side_length = size.to_f
    corners = [Point(center.x - side_length / 2, center.y - side_length / 2),
               Point(center.x + side_length / 2, center.y - side_length / 2),
               Point(center.x + side_length / 2, center.y + side_length / 2),
               Point(center.x - side_length / 2, center.y + side_length / 2)]
    corners.map! { |point| point.rotate_around(center, angle) }
    color = (size > 0) ? @window.default_color : 0xfff00000
    @window.rectangle(corners, color)
  end

  def draw
    @window.line(track_axis)
    
    @window.triangle(Point(position.x - 3, position.y).rotate_around(position, angle),
                     Point(position.x, position.y + 5.2).rotate_around(position, angle),
                     Point(position.x + 3, position.y).rotate_around(position, angle))
    draw_track(left_track, 8 * left_track_power)
    draw_track(right_track, 8 * right_track_power)
    
    #@window.line(Line(Point.new(-200, 0), Point.new(200, 0)), 0xf0333333)
    #@window.line(Line(Point.new(0, -200), Point.new(0, 200)), 0xf0333333)
    
    #@window.line(Line(self.intersection_point, self.advanced_track_axis.point1), 0xf00aaff0)
    #@window.square(self.intersection_point, 6, 0xf00aaff0) unless self.intersection_point.nil?
  end
  
  def initialize(window)
    @left_track = Point(-20, 0)
    @right_track = Point(20, 0)
    
    @left_track_power = 0
    @right_track_power = 0
        
    @window = window
  end
end

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Tracks"

    @player = Player.new(self)
    @player.move_tracks(1)

    @lines = []
    3.times { @lines << Gosu::Font.new(self, Gosu::default_font_name, 20) }
  end

  def default_color
    0xffffff00
  end

  def line(line, color=default_color)
    draw_line(line.point1.to_screen.x, line.point1.to_screen.y, color, line.point2.to_screen.x, line.point2.to_screen.y, color)
  end
  
  def triangle(point1, point2, point3)
    draw_triangle(point1.to_screen.x, point1.to_screen.y, default_color, 
                  point2.to_screen.x, point2.to_screen.y, default_color, 
                  point3.to_screen.x, point3.to_screen.y, default_color)
  end
  
  def rectangle(corners, color=default_color)
    draw_quad(corners[0].to_screen.x, corners[0].to_screen.y, color,
              corners[1].to_screen.x, corners[1].to_screen.y, color,
              corners[2].to_screen.x, corners[2].to_screen.y, color,
              corners[3].to_screen.x, corners[3].to_screen.y, color)
  end
  
  def square(center, side_length, color=default_color)
    side_length = side_length.to_f.abs
    corners = [Point(center.x - side_length / 2, center.y - side_length / 2),
               Point(center.x + side_length / 2, center.y - side_length / 2),
               Point(center.x + side_length / 2, center.y + side_length / 2),
               Point(center.x - side_length / 2, center.y + side_length / 2)]    
    self.rectangle(corners, color)
  end

  def update
    step = 0.02
    if button_down? Gosu::KbPageUp
      @player.right_track_power += step unless @player.right_track_power >= 1
    end

    if button_down? Gosu::KbPageDown      
      @player.right_track_power -= step unless @player.right_track_power <= -1
    end

    if button_down? Gosu::KbUp
      @player.left_track_power += step unless @player.left_track_power >= 1
    end
    
    if button_down? Gosu::KbDown
      @player.left_track_power -= step unless @player.left_track_power <= -1
    end
    
    @player.left_track_power = 0 if button_down?(Gosu::KbLeft) or button_down?(Gosu::KbRight)
    @player.right_track_power = 0 if button_down?(Gosu:: KbHome) or button_down?(Gosu::KbEnd)
    
    @player.move_tracks(1)
  end

  def draw
    @player.draw

    @lines[0].draw("position: (#{@player.position.x.to_i}, #{@player.position.y.to_i}) angle: #{(@player.angle * 180 / Math::PI).to_i} ", 10, 10, 3, 1.0, 1.0, default_color)
    @lines[1].draw("track power: [#{@player.left_track_power}, #{@player.right_track_power}]", 10, 30, 3, 1.0, 1.0, default_color)
    #@lines[2].draw("left track: (#{@player.left_track.x.to_i}, #{@player.left_track.y.to_i}), right track: (#{@player.right_track.x.to_i}, #{@player.right_track.y.to_i})", 10, 50, 3, 1.0, 1.0, default_color)
  end

  def button_down(id)
    if id == Gosu::KbEscape then
      close
    end
  end
end

GameWindow.new.show
