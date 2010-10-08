module Graphics
  class Recharger < Base
    alias :recharger :object

    extend Forwardable

    def_delegators :recharger, :position, :player

    def draw
      surface.circle(position, GeekGame::Recharger::RANGE, player.color)
    end
  end
end
