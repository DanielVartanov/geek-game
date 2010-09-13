class Vector < Struct.new(:x, :y)
  def self.by_end_points(origin_point, end_point)
    self.new(end_point.x - origin_point.x, end_point.y - origin_point.y)
  end
  
  def modulus      
    Math.hypot(x ,y)
  end

  def scalar_product(vector)
    x * vector.x + y * vector.y
  end

  # z-coordinate of cross product (also known as vector product or outer product)
  # It is positive if other vector should be turned counter-clockwise in order to superpose them.
  # It is negetive if other vector should be turned clockwise in order to superpose them.
  # It is zero when vectors are collinear.
  # Remark: x- and y- coordinates of plane vectors cross product are always zero
  def cross_product(vector)
    x * vector.y - y * vector.x
  end
  
  def rotate(angle)
    self.to_point.rotate_around(Point[0, 0], angle).to_radius
  end
  
  def +(vector)
    Vector.new(x + vector.x, y + vector.y)
  end

  def angle_with(vector)
    cos_alpha = self.scalar_product(vector) / (self.modulus * vector.modulus)
    alpha = Math.acos(cos_alpha)
    alpha = -alpha if cross_product(vector) < 0
    alpha
  end
  
  def to_point
    Point.new(self.x, self.y)
  end
end

def Vector(x, y)
  Vector.new(x, y)
end
