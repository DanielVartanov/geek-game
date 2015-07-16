module Graphics
  class Engineer < TrackedBot
    def axis_length
      GeekGame::Engineer.axis_length
    end

    def draw
      super
      draw_metal_bars if metal_bars_carried
    end

    def draw_metal_bars
      datum_point = position.advance_by(Vector(axis_length / 2 + 10, -20))
      5.times.map do |index|
        surface.line Line.new(datum_point.advance_by(Vector(0, 2 * index)), datum_point.advance_by(Vector(4, 2 * index))), METAL_COLOR
      end
    end
  end
end
