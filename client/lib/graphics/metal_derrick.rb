module Graphics
  class MetalDerrick < Base
    alias :metal_derrick :game_object

    def draw
      draw_body
      draw_metal_bars
    end

    protected

    METAL_COLOR = [0x46, 0x82, 0xb4]

    def draw_body
      surface.solid_circle position, 10, inner_color_by_progress
    end

    def inner_color_by_progress
      METAL_COLOR.map do |color_element|
        color_element * (0.2 + 0.8 * progress)
      end
    end

    def draw_metal_bars
      return unless metal_bars_available

      datum_point = position.advance_by Vector(12, -8)
      5.times.map do |index|
        surface.line Line.new(datum_point.advance_by(Vector(0, 2 * index)), datum_point.advance_by(Vector(4, 2 * index))), METAL_COLOR
      end
    end
  end
end
