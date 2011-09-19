module Graphics
  class Factory < Base
    alias :factory :game_object

    def draw
      radius = 25
      surface.draw_circle_a(position.to_screen(surface), radius, surface.default_color)
      if factory.producing?
        surface.draw_circle_a(position.to_screen(surface), radius * factory.progress, [0, 0xff, 0])
      end        
    end
  end
end
