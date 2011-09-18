require "active_support/inflector"

module GeekGame
  class GameObject < Struct.new(:player, :position, :angle)
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

    def to_hash
      {
        :id => id,
        :type => self.class.to_s.demodulize.underscore,
        :position => position.to_array,
        :angle => angle
      }
    end

    alias :id :object_id

    protected

    attr_writer :birth_time
  end  
end
