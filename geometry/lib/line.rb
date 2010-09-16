class Line < Struct.new(:point1, :point2)
  def intersection_point_with(line)
    # TODO: raise if overlaps?(line)
    # TODO: raise if parallel_to?(line)
    
    numerator = (line.point1.y - point1.y) * (line.point1.x - line.point2.x) -
      (line.point1.y - line.point2.y) * (line.point1.x - point1.x);
    denominator = (point2.y - point1.y) * (line.point1.x - line.point2.x) - 
      (line.point1.y - line.point2.y) * (point2.x - point1.x);

    t = numerator.to_f / denominator;
    
    x = point1.x + t * (point2.x - point1.x)
    y = point1.y + t * (point2.y - point1.y)            

    Point(x, y)
  end
  
  def angle_with(line)
    self.to_vector.angle_with(line.to_vector)
  end
  
  def to_vector
    Vector.by_end_points(self.point1, self.point2)
  end

  def to_s
    "Line(#{point1}, #{point2})"
  end
end

def Line(point1, point2)
  Line.new(point1, point2)
end
