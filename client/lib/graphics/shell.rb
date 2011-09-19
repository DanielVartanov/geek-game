require 'forwardable'

module Graphics
  class Shell < Base
    alias :shell :game_object

    def draw
      draw_body
      draw_warhead
    end

    protected

    def draw_body
      surface.draw_circle_s(position.to_screen(surface), 3, [0xff, 0, 0xff])
    end

    def draw_warhead
      #surface.draw_triangle()
    end
  end
end
