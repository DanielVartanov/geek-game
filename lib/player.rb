module GeekGame
  class Player
    attr_reader :color, :factory

    def initialize(options)
      self.color = options[:color]

      self.factory = Factory.new :position => options[:position],
        :orientation => options[:orientation],
        :player => self
    end

    protected

    attr_writer :factory, :color
  end
end
