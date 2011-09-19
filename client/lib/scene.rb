module GeekGame
  class Scene < Struct.new(:screen, :font)
    attr_accessor :game_object_images

    def initialize(*args)
      super
      self.game_object_images = {}
    end
    
    def update_according_to(game_objects)
      puts game_objects.inspect
      
      ids_to_destroy = game_object_images.keys - game_objects.keys
      ids_to_destroy.each do |id|
        game_object_images.delete(id)
      end
      
      ids_to_create = game_objects.keys - game_object_images.keys
      ids_to_create.each do |id|
        game_object_images[id] = Graphics::Base.create_from game_objects[id], :surface => screen
      end

      puts "ids_to_destroy = #{ids_to_destroy.inspect}"
      puts "ids_to_create = #{ids_to_create.inspect}"

      game_objects.keys.each do |id|
        game_object_images[id].update! game_objects[id]
      end
    end

    def draw
      screen.fill(:black)
      game_object_images.values.each(&:draw)
      screen.draw_text_info(font, "Game has begun")
      screen.flip
    end
    
    def default_color
      [0xff, 0xff, 00]
    end
  end
end
