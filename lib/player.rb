module GeekGame
  class Player
    attr_reader :color, :factory

    def initialize(options)
      self.color = options[:color]
    end

    def factory=(factory)
      factory.player = self
      @factory = factory
    end    

    protected

    attr_writer :color
  end
end
