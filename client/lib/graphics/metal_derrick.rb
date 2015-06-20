module Graphics
  class MetalDerrick < Base
    alias :metal_derrick :game_object

    def draw
      draw_body
    end

    protected

    def draw_body
      surface.solid_circle position, 10, [0x46, 0x82, 0xb4]
    end
  end
end
