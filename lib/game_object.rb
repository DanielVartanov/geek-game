module GeekGame
  class GameObject
    def initialize
      GeekGame.game_objects << self
    end

    def die!
      GeekGame.game_objects.delete(self)
    end
  end  
end
