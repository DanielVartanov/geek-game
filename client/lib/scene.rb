module GeekGame
  class Scene < Struct.new(:screen, :font)
    attr_accessor :game_object_images

    def initialize(*args)
      super
      extend_screen
      self.game_object_images = {}
    end

    def update_according_to(game_objects)
      ids_to_destroy = game_object_images.keys - game_objects.keys
      ids_to_destroy.each do |id|
        game_object_images.delete(id)
      end

      ids_to_create = game_objects.keys - game_object_images.keys
      ids_to_create.each do |id|
        game_object_images[id] = Graphics::Base.create_from game_objects[id], surface: screen
      end

      game_objects.keys.each do |id|
        game_object_images[id].update! game_objects[id]
      end
    end

    def draw
      screen.fill(:black)
      game_object_images.values.each(&:draw)
      screen.draw_text_info(font, ["Number of objects: #{game_object_images.count}", "Scale: #{screen.scale}"])
      screen.flip
    end

    def extend_screen
      class << screen
        attr_accessor :scale

        include Shapes
        include HUD

        def default_color
          [0xaa, 0xaa, 0x00]
        end
      end

      screen.scale = 1
    end
  end
end
