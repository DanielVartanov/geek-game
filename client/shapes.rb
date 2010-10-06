module Shapes
  def draw_polygon_s( points, color )
    _draw_polygon( points, color, true, true )
    return self
  end
  
  def line(line, color=default_color)
    draw_line(line.point1.to_screen(self), line.point2.to_screen(self), color)
  end

  def triangle(point1, point2, point3, color=default_color)
    points = [point1, point2, point3].map { |point| point.to_screen(self) }
    draw_polygon_s(points, color)
  end

  def rectangle(corners, color=default_color)
    corners.map! { |point| point.to_screen(self)  }
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
