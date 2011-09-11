module GeekGame
  class World
    def initialize
      @red = Player.new :color => [0xff, 0, 0]
      @red.factory = Factory.new :position => Point(-800, -400), :angle => 45.degrees
      Recharger.new :position => @red.factory.position, :player => @red

      @blue = Player.new :color => [0, 0, 0xff]
      @blue.factory = Factory.new :position => Point(800, 400), :angle => -135.degrees
      Recharger.new :position => @blue.factory.position, :player => @blue
    end
    
    def update(seconds_passed)
      update_game_objects(seconds_passed)
      handle_collisions
    end

    protected

    def update_game_objects(seconds_passed)
      GeekGame.game_objects.update(seconds)
    end

    def handle_collisions
      GeekGame.game_objects.shells.each do |shell|
        GeekGame.game_objects.bots.each do |bot|
          if shell.owner != bot and shell.hit?(bot)
            bot.take_damage(shell.damage)
            shell.die!
          end
        end
      end
    end
  end
end
