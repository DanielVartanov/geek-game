class Point < Struct.new(:x, :y)
  def ==(another_point)
    x === another_point.x && y === another_point.y
  end

  def distance_to(point)
    Math.hypot point.x - self.x, point.y - self.y
  end

  def rotate_around(center, angle)
    diff = Point.new(self.x - center.x, self.y - center.y)
    Point.new(center.x + diff.x * Math.cos(angle) - diff.y * Math.sin(angle), 
              center.y + diff.x * Math.sin(angle) + diff.y * Math.cos(angle))
  end

  def to_radius
    Vector(self.x, self.y)
  end  
end

def Point(x, y)
  Point.new(x, y)
end
