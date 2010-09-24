module GeekGame
  class GameObject
    def initialize
      GeekGame.game_objects << self
    end
  end  
end
