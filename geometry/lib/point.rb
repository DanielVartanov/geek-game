class Point < Struct.new(:x, :y)
  def ==(another_point)
    x === another_point.x && y === another_point.y
  end

  def distance_to(point)
    Math.hypot point.x - self.x, point.y - self.y
  end

  def vector_to(point)
    Vector.by_end_points(self, point)
  end

  def rotate_around(center, angle)
    diff = Point.new(self.x - center.x, self.y - center.y)
    Point.new(center.x + diff.x * Math.cos(angle) - diff.y * Math.sin(angle),
              center.y + diff.x * Math.sin(angle) + diff.y * Math.cos(angle))
  end

  def advance_by(vector)
    (to_radius + vector).to_point
  end

  def to_radius
    Vector(self.x, self.y)
  end

  def to_s
    "Point(#{x}, #{y})"
  end

  def to_a
    [x, y]
  end
  alias :to_array :to_a
end

def Point(x, y)
  Point.new(x, y)
end
