module GeekGame
  module TrackedBotExtensions
    attr_accessor :threshold

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
      when -1
        motor!(1, 1 - power)
      when 0
        motor!(1, 1)
      when 1
        motor!(1 - power, 1)
      end
    end

    def close_enough_to_shoot(target)
      distance_to(target) < Shell::MAX_RANGE
    end

    def worth_fire?(target)
      angle_to(target) - gun_angle < 10.degrees and close_enough_to_shoot(target)
    end

    def engage(target)
      advance_to(target)
      stop! if distance_to(target) < 300
    end

    def turn_aside
      direction = (rand * 2 - 1).sign
      if direction > 0
        motor!(0, 1)
      else
        motor!(1, 0)
      end
    end

    def shoot(target)
      aim(target)
      fire! if worth_fire?(target)
    end

    def stopped?
      left_track.power.zero? and right_track.power.zero?
    end
  end

  TrackedBot.class_eval { include TrackedBotExtensions }

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
      player.factory.produce!
      dangerous_bots = enemy_bots.reject { |bot| bot.battery.charge < bot.shooting_cost }
      target = dangerous_bots.sort { |left, right| left.health_points <=> right.health_points }.first
      return if target.nil?
      my_bots.each do |bot|
        if bot.stopped?
          bot.turn_aside
          bot.threshold = 0.2 + rand * 0.8
        end
        bot.motor!(1, 1) if bot.life_time > bot.threshold and bot.life_time < bot.threshold * 12
        bot.engage(target) if bot.life_time > bot.threshold * 12
        if bot.battery.charge < 0.2
          bot.engage(player.factory)
        else
          bot.shoot(target)
        end
      end
    end
  end
end
