module Graphics
  class Factory < Base
    alias :factory :object

    extend Forwardable

    def_delegators :factory, :position, :angle, :player

    def draw
      radius = 25
      surface.draw_circle_a(position.to_screen(surface), radius, player.color)
      if factory.producing?
        surface.draw_circle_a(position.to_screen(surface), radius * factory.progress, [0, 0xff, 0])
      end        
    end
  end
end
