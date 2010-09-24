require 'forwardable'

module Graphics
  class TrackedBot < Base
    alias :tracked_bot :object

    extend Forwardable

    def_delegators :tracked_bot, :position, :angle, :track_axis, :left_track, :right_track,
                   :left_track_position, :right_track_position, :gun_angle, :shells

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
      barrel_end = position.advance_by(Vector(1, 0).rotate(gun_angle) * (::TrackedBot::AXIS_LENGTH / 2))
      surface.line(Line(position, barrel_end), [0, 0xff, 0])
    end

    def draw_shell(shell)
      surface.draw_circle_s(shell.position.to_screen(surface), 3, [0, 0, 0xff])
    end

    def draw_triangle(base)
      surface.triangle(Point(base.x - 3, base.y).rotate_around(base, angle),
                       Point(base.x, base.y + 5.2).rotate_around(base, angle),
                       Point(base.x + 3, base.y).rotate_around(base, angle))
    end

    def draw
      surface.line(track_axis)

      axis_vector = Vector(1, 0).rotate(angle)

      draw_triangle(position.advance_by(axis_vector * (::TrackedBot::AXIS_LENGTH / 4)))
      draw_triangle(position.advance_by(axis_vector * (::TrackedBot::AXIS_LENGTH / 4 * (-1))))
            
      draw_track(left_track_position, 8 * left_track.power)
      draw_track(right_track_position, 8 * right_track.power)

      draw_gun

      shells.each do |shell|
        draw_shell(shell)
      end
    end
  end
end
