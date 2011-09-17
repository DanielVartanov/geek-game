module GeekGame
  class World
    def update(seconds_passed)
      update_game_objects(seconds_passed)
      handle_collisions
    end

    protected

    def update_game_objects(seconds_passed)
      GeekGame.game_objects.update(seconds_passed)
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
