module GeekGame
  class GameObject
    attr_reader :birth_time
    
    def initialize
      GeekGame.game_objects << self
      self.birth_time = Time.now
    end

    def die!
      GeekGame.game_objects.delete(self)
    end

    def life_time
      Time.now - birth_time
    end    

    protected

    attr_writer :birth_time
  end  
end
