module Graphics
  class EngineerFactory < Base
    def draw
      radius = 12.5
      surface.draw_circle_a(position.to_screen(surface), radius, player_color)
    end
  end
end
