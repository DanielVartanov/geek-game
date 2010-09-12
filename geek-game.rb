require 'rubygems'
require 'gosu'

class Point < Struct.new(:x, :y)
  def rotate_around(center, angle)
    diff = Point.new(self.x - center.x, self.y - center.y)
    Point.new(center.x + diff.x * Math.cos(angle) - diff.y * Math.sin(angle), 
              center.y + diff.x * Math.sin(angle) + diff.y * Math.cos(angle))
  end
  
  def to_screen
    Point.new(320 + self.x, 240 - self.y)
  end
end

class Player
  attr_accessor :position, :angle

  def initialize(window)
    @position = Point.new(0, 0)
    @angle = 0
    @window = window
  end
  
  def left_track
    Point.new(@position.x - 20, @position.y).rotate_around(@position, @angle)
  end

  def right_track
    Point.new(@position.x + 20, @position.y).rotate_around(@position, @angle)
  end
  
  def draw_track(center)
    side_length = 8.to_f
    corners = [Point.new(center.x - side_length / 2, center.y - side_length / 2),
               Point.new(center.x + side_length / 2, center.y - side_length / 2),
               Point.new(center.x + side_length / 2, center.y + side_length / 2),
               Point.new(center.x - side_length / 2, center.y + side_length / 2)]
    corners.map! { |point| point.rotate_around(@position, @angle) }
    @window.rectangle(corners)
  end

  def draw
    @window.line(left_track, right_track)
    @window.triangle(Point.new(@position.x - 3, @position.y).rotate_around(@position, @angle),
                     Point.new(@position.x, @position.y + 5.2).rotate_around(@position, @angle),
                     Point.new(@position.x + 3, @position.y).rotate_around(@position, @angle))
    draw_track(Point.new(@position.x - 20, @position.y))
    draw_track(Point.new(@position.x + 20, @position.y))
  end

  def turn_clock_wise(delta)
    @angle = (@angle - delta) % (2 * Math::PI)
  end

  def turn_counter_clock_wise(delta)
    @angle = (@angle + delta) % (2 * Math::PI)
  end
  
  def move_ahead(distance)
    @position = Point.new(@position.x, @position.y + distance).rotate_around(@position, @angle)
  end
end

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Tracks"
    
    @player = Player.new(self)

    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
  end

  def default_color
    0xffffff00
  end

  def line(point1, point2, color=default_color)
    draw_line(point1.to_screen.x, point1.to_screen.y, color, point2.to_screen.x, point2.to_screen.y, color)
  end
  
  def triangle(point1, point2, point3)
    draw_triangle(point1.to_screen.x, point1.to_screen.y, default_color, 
                  point2.to_screen.x, point2.to_screen.y, default_color, 
                  point3.to_screen.x, point3.to_screen.y, default_color)
  end
  
  def rectangle(corners)
    draw_quad(corners[0].to_screen.x, corners[0].to_screen.y, default_color,
              corners[1].to_screen.x, corners[1].to_screen.y, default_color,
              corners[2].to_screen.x, corners[2].to_screen.y, default_color,
              corners[3].to_screen.x, corners[3].to_screen.y, default_color)
  end

  def update
    if button_down? Gosu::KbLeft
      @player.turn_counter_clock_wise(3 * Math::PI / 180) # 5.radians
    end

    if button_down? Gosu::KbRight
      @player.turn_clock_wise(3 * Math::PI / 180)
    end

    if button_down? Gosu::KbUp
      @player.move_ahead(1.5)
    end
  end

  def draw
    @player.draw
    @font.draw("x: #{@player.position.x.to_i} y: #{@player.position.y.to_i} angle: #{(@player.angle * 180 / Math::PI).to_i}", 10, 10, 3, 1.0, 1.0, default_color)
  end

  def button_down(id)
    if id == Gosu::KbEscape then
      close
    end
  end
end

GameWindow.new.show