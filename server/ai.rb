module GeekGame
  module TrackedBotExtensions
    def vector_to(target)
      Vector.by_end_points(self.position, target.position)
    end
    
    def angle_to(target)
      Vector(1, 0).signed_angle_with(vector_to(target))
    end

    def distance_to(target)
      position.distance_to(target.position)
    end

    def stop!
      motor!(0, 0)
    end

    def aim(target)
      angle_diff = angle_to(target) - gun_angle
      gun.rotate(angle_diff)
    end

    def advance_to(target)
      movement_vector = Vector(1, 0).rotate(angle).rotate(90.degrees)
      angle_diff = movement_vector.signed_angle_with(vector_to(target))
      power = angle_diff.abs < 45.degrees ? angle_diff.abs / 90.degrees : 1

      case angle_diff.sign
      when -1: motor!(1, 1 - power)
      when 0: motor!(1, 1)
      when 1: motor!(1 - power, 1)
      end
    end

    def close_enough_to_shoot(target)
      distance_to(target) < Shell::MAX_RANGE
    end

    def worth_fire?(target)
      angle_to(target) - gun_angle < 10.degrees and close_enough_to_shoot(target)
    end

    def engage(target)
      aim(target)
      advance_to(target)
      stop! if distance_to(target) < 300
      fire! if worth_fire?(target)
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
