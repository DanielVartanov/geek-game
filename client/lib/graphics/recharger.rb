module Graphics
  class Recharger < Base
    alias :recharger :game_object

    def draw
      surface.circle(position, GeekGame::Recharger.range)
    end
  end
end
