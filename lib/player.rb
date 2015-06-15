module GeekGame
  class Player
    attr_accessor :color, :recharger

    def initialize(options)
      self.color = options[:color]
    end
  end
end
