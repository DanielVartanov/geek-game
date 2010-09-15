require 'forwardable'

module Graphics
  class TrackedBot < Base
    alias :tracked_bot :object

    extend Forwardable

    def_delegators :tracked_bot, :position, :angle, :left_track_power, :right_track_power, :track_axis,
                   :left_track, :right_track

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

    def draw
      surface.line(track_axis)
      
      surface.triangle(Point(position.x - 3, position.y).rotate_around(position, angle),
                       Point(position.x, position.y + 5.2).rotate_around(position, angle),
                       Point(position.x + 3, position.y).rotate_around(position, angle))

      draw_track( left_track, 8 * left_track_power)
      draw_track(right_track, 8 * right_track_power)
    end
  end
end
