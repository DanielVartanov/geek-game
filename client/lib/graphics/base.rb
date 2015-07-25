module Graphics
  class Base < Struct.new(:game_object, :surface)
    def self.create_from(game_object, surface:)
      klass_name = game_object[:type].camelize
      klass = Graphics.const_get(klass_name)

      klass.new game_object, surface
    end

    def method_missing(method_name, *args)
      if game_object.key?(method_name)
        game_object[method_name]
      else
        super
      end
    end

    def update!(game_object)
      self.game_object = game_object
    end

    def position
      Point(*game_object[:position])
    end
  end
end
