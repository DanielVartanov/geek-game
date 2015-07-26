class Vector < Struct.new(:x, :y)
  def self.by_end_points(origin_point, end_point)
    self.new(end_point.x - origin_point.x, end_point.y - origin_point.y)
  end

  def self.polar(modulus, angle)
    self.new(modulus * Math.cos(angle), modulus * Math.sin(angle))
  end

  def ==(another_vector)
    x === another_vector.x && y === another_vector.y
  end

  def modulus
    Math.hypot(x ,y)
  end

  def angle
    Vector(1, 0).signed_angle_with(self)
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

  def collinear_with?(vector)
    cross_product(vector) === 0
  end

  def same_direction_as?(vector)
   collinear_with?(vector) && scalar_product(vector) > 0
  end

  def rotate(angle)
    self.to_point.rotate_around(Point(0, 0), angle).to_radius
  end

  def +(vector)
    Vector.new(x + vector.x, y + vector.y)
  end

  def *(scalar)
    Vector.new(x * scalar, y * scalar)
  end

  def reverse
    self * -1
  end

  def angle_with(vector)
    cos_alpha = self.scalar_product(vector) / (self.modulus * vector.modulus)
    cos_alpha = 1 if cos_alpha > 1
    cos_alpha = -1 if cos_alpha < -1
    Math.acos(cos_alpha)
  end

  def signed_angle_with(vector)
    cross_product(vector).zero? ?
      angle_with(vector) :
      angle_with(vector) * cross_product(vector).sign
  end

  def to_point
    Point.new(self.x, self.y)
  end

  def to_s
    "Vector(#{x}, #{y})"
  end
end

def Vector(x, y)
  Vector.new(x, y)
end
