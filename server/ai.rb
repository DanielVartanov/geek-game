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

    def advance_to(target)
      angle_diff = normalized_movement_vector.signed_angle_with(vector_to(target))
      power = angle_diff.abs < 45.degrees ? angle_diff.abs / 90.degrees : 1

      case angle_diff.sign
      when -1
        motor!(1, 1 - power)
      when 0
        motor!(1, 1)
      when 1
        motor!(1 - power, 1)
      end
    end

    def turn_aside
      direction = (rand * 2 - 1).sign
      if direction > 0
        motor!(0, 1)
      else
        motor!(1, 0)
      end
    end

    def stopped?
      left_track.power.zero? and right_track.power.zero?
    end
  end

  module PewPewExtentions
    def aim(target)
      angle_diff = angle_to(target) - gun.absolute_angle
      gun.rotate(angle_diff)
    end

    def close_enough_to_shoot(target)
      distance_to(target) < Shell::MAX_RANGE
    end

    def worth_fire?(target)
      angle_to(target) - gun.absolute_angle < 10.degrees and close_enough_to_shoot(target)
    end

    def engage(target)
      advance_to(target)
      stop! if distance_to(target) < 300
    end

    def shoot(target)
      aim(target)
      fire! if worth_fire?(target)
    end
  end

  TrackedBot.class_eval { include TrackedBotExtensions }
  PewPew.class_eval { include PewPewExtentions }

  class AI
    attr_accessor :player

    def initialize(player)
      self.player = player
    end

    def my_bots
      GeekGame.game_objects.bots.select { |bot| bot.player == player }
    end

    def enemy_bots
      GeekGame.game_objects.bots - my_bots
    end

    def act!(seconds)
      my_bots.select { |bot| bot.is_a?(PewPew) }.each do |bot|
        target = enemy_bots.sort { |left, right| bot.distance_to(left) <=> bot.distance_to(right) }.first
        return if target.nil?

        if bot.battery.charge < 0.2
          bot.advance_to(player.recharger)
        else
          bot.engage(target)
          bot.shoot(target)
        end
      end
    end
  end
end
