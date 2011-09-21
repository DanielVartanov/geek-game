require 'forwardable'

module Graphics
  class TrackedBot < Base
    alias :tracked_bot :game_object

    def draw_track(center, size)
      side_length = size.to_f
      corners = [Point(center.x - side_length / 2, center.y - side_length / 2),
                 Point(center.x + side_length / 2, center.y - side_length / 2),
                 Point(center.x + side_length / 2, center.y + side_length / 2),
                 Point(center.x - side_length / 2, center.y + side_length / 2)]
      corners.map! { |point| point.rotate_around(center, angle) }
      color = (size > 0) ? surface.default_color : [0xff, 0x00, 0x00]
      surface.rectangle(corners, color)
    end

    def draw_gun
      barrel_end = position.advance_by(Vector(1, 0).rotate(gun_angle) * (GeekGame::TrackedBot::AXIS_LENGTH / 2))
      surface.line(Line(position, barrel_end), [0, 0xff, 0])
    end

    def draw_triangle(base)
      surface.triangle(Point(base.x - 3, base.y).rotate_around(base, angle),
                       Point(base.x, base.y + 5.2).rotate_around(base, angle),
                       Point(base.x + 3, base.y).rotate_around(base, angle))
    end

    def draw_health_bar
      full_length = GeekGame::TrackedBot::AXIS_LENGTH
      length = full_length * tracked_bot.health_points.to_f / GeekGame::TrackedBot::MAX_HEALTH_POINTS
      height = 3

      left_top = position.advance_by(Vector(-full_length.to_f / 2, full_length.to_f / 2 + 15))
      
      corners = [left_top,
                 left_top.advance_by(Vector(length, 0)),
                 left_top.advance_by(Vector(length, -height)),
                 left_top.advance_by(Vector(0, -height))
                ]
      surface.rectangle(corners)
    end

    def draw_battery_charge
      full_length = GeekGame::TrackedBot::AXIS_LENGTH * 0.75
      actual_length = full_length * tracked_bot.battery.charge
      width = 3

      left_bottom = position.advance_by(Vector(-GeekGame::TrackedBot::AXIS_LENGTH / 2 - 10, -20))

      corners = [left_bottom,
                 left_bottom.advance_by(Vector(0, actual_length)),
                 left_bottom.advance_by(Vector(width, actual_length)),
                 left_bottom.advance_by(Vector(width, 0))
                ]
      surface.rectangle(corners, [128, 255, 128])
    end

    def draw_axis
      surface.line(track_axis)
    end

    def draw
      surface.square(position, 15)

=begin      
      draw_axis

      axis_vector = Vector(1, 0).rotate(angle)

      draw_triangle(position.advance_by(axis_vector * (GeekGame::TrackedBot::AXIS_LENGTH / 4)))
      draw_triangle(position.advance_by(axis_vector * (GeekGame::TrackedBot::AXIS_LENGTH / 4 * (-1))))
            
      draw_track(left_track_position, 8 * left_track.power)
      draw_track(right_track_position, 8 * right_track.power)

      draw_gun

      draw_health_bar

      draw_battery_charge
=end
    end
  end
end
