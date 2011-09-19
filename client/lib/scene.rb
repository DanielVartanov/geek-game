module GeekGame
  class Scene < Struct.new(:screen, :font)
    def update_according_to(game_objects)
      ids_to_destroy = [game_object_images.keys - game_objects.keys]
      ids_to_destroy.each do |id|
        game_object_images[id].die!
      end
      
      ids_to_create = [game_objects.keys - game_object_images.keys]
      ids_to_create.each do |id|
        GameObjectImage.create_from game_objects[id]
      end

      game_objects.each do |game_object|
        game_object_images[game_object.id].update!(game_object)
      end
    end

    def draw
      screen.fill(:black)

      game_object_images.bots.each { |bot| Graphics::TrackedBot.new(bot, screen).draw }
      game_object_images.shells.each { |shell| Graphics::Shell.new(shell, screen).draw }
      game_object_images.factories.each { |factory| Graphics::Factory.new(factory, screen).draw }
      game_object_images.rechargers.each { |recharger| Graphics::Recharger.new(recharger, screen).draw }

      screen.draw_text_info(font, "Game has begun")

      screen.flip
    end
    
    def default_color
      [0xff, 0xff, 00]
    end
  end
end
