module Graphics
  class Factory < Base
    def draw
      draw_hull
      draw_progress if producing
      draw_metal_bars
    end

    def draw_hull
      surface.circle(position, self.class.radius, player_color)
    end

    def draw_progress
      surface.circle(position, self.class.radius * progress, player_color)
    end

    def draw_metal_bars
      datum_point = position.advance_by(Vector(self.class.radius + 10, -20))
      metal_bars_count.times.map do |index|
        surface.line Line.new(datum_point.advance_by(Vector(0, 2 * index)), datum_point.advance_by(Vector(4, 2 * index))), METAL_COLOR
      end
    end
  end
end
