module GeekGame
  module TrackedBotExtensions
    def aim(target)
      angle_to_target = Vector(1, 0).signed_angle_with(Vector.by_end_points(self.position, target.position))
      angle_diff = angle_to_target - gun_angle

      gun.rotate(angle_diff)
    end

    def engage(target)
      aim(target)
      #fire(target)
    end
  end

  TrackedBot.class_eval { include TrackedBotExtensions }

  class AI
    attr_accessor :my_bots
    
    def initialize(my_bots)
      self.my_bots = my_bots
    end

    def enemy_bots
      GeekGame.game_objects.bots - my_bots
    end

    def act!(seconds)
      target = enemy_bots.first
      return if target.nil?
      my_bots.each do |my_bot|
        my_bot.engage(target)
      end
    end
  end
end
