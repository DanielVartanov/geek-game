require 'forwardable'

module Graphics
  class Shell < Base
    alias :shell :game_object

    def draw
      draw_body
    end

    protected

    def draw_body
      surface.solid_circle(position, 2, [0xff, 0, 0xff])
    end
  end
end
