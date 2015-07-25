module Shapes
  def draw_polygon_s(points, color=default_color)
    _draw_polygon points.map { |point| point.to_screen(self) }, color, true, true
  end

  def circle(center, radius, color=default_color)
    draw_circle_a(center.to_screen(self), radius * scale, color)
  end

  def solid_circle(center, radius, color=default_color)
    draw_circle_s(center.to_screen(self), radius * scale, color)
  end

  def line(line, color=default_color)
    draw_line(line.point1.to_screen(self), line.point2.to_screen(self), color)
  end

  def triangle(point1, point2, point3, color=default_color)
    draw_polygon_s([point1, point2, point3], color)
  end

  def rectangle(corners, color=default_color)
    draw_polygon_s(corners, color)
  end

  def square(center, side_length, color=default_color)
    side_length = side_length.to_f.abs
    corners = [Point(center.x - side_length / 2, center.y - side_length / 2),
               Point(center.x + side_length / 2, center.y - side_length / 2),
               Point(center.x + side_length / 2, center.y + side_length / 2),
               Point(center.x - side_length / 2, center.y + side_length / 2)]
    rectangle(corners, color)
  end
end
