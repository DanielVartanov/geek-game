module Graphics
  class Factory < Base
    alias :factory :game_object

    def draw
      radius = 25
      surface.draw_circle_a(position.to_screen(surface), radius, player_color)
    end
  end
end
