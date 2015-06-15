module Graphics
  class PewPewFactory < Base
    def draw
      radius = 25
      surface.draw_circle_a(position.to_screen(surface), radius, player_color)
    end
  end
end
