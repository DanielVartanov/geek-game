class Numeric
  def degrees
    self.to_f / 180 * Math::PI
  end

  def sign
    self.zero? ? 0 : self <=> 0.0
  end

  def ===(other)
    (self - other).abs <= Float::EPSILON * 2
  end
end

class Float  
  def zero?
    self === 0.0
  end
end
