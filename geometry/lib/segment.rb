
class Segment < Struct.new(:point1, :point2)
  def middle_point
    Point.new(
      point1.x + (point2.x - point1.x).to_f / 2,
      point1.y + (point2.y - point1.y).to_f / 2
    )
  end
  
  def length
    self.point1.distance_to(self.point2)
  end
end

def Segment(point1, point2)
  Segment.new(point1, point2)
end
