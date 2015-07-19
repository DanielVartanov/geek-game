module GeekGame
  module TrackedBotExtensions
    def angle_to(target)
      Vector(1, 0).signed_angle_with(vector_to(target))
    end

    def stop!
      motor!(0, 0)
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

    def aim(target)
      angle_diff = angle_to(target) - gun.absolute_angle
      gun.rotate(angle_diff)
    end

    def close_enough_to_shoot(target)
      distance_to(target) < Shell::MAX_RANGE
    end

    def worth_fire?(target)
      (angle_to(target) - gun.absolute_angle).abs < 10.degrees and close_enough_to_shoot(target)
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

  module EngineerExtentions
    def move_to(target, hold_off_distance)
      angle_diff = normalized_movement_vector.signed_angle_with(vector_to(target))
      sign = angle_diff.sign

      distance = distance_to(target) - hold_off_distance
      power = [[distance / 50, 1].min, 0.25].max

      if sign === 0
        motor! power, power
      elsif sign > 0
        motor! (1 - angle_diff / 180.degrees * 2) * power, power
      else
        motor! power, (1 + angle_diff / 180.degrees * 2) * power
      end
    end

    def turn_to(target, precision)
      angle_diff = normalized_movement_vector.signed_angle_with(vector_to(target))
      sign = angle_diff.sign

      power = [angle_diff.abs / 90.degrees, 1].min

      motor! -power * sign, power * sign
    end

    def advance_to(target, hold_off_distance)
      distance = distance_to(target)
      if distance > hold_off_distance
        move_to target, hold_off_distance - 1
      else
        turn_to target, 0.05.degrees
      end
    end

    def engage(facility)
      advance_to(facility, facility.connection_distance)
      if distance_to(facility) <= facility.connection_distance
        unless connected_to_facility?
          connect_to(facility)
        end
      end
    end

    def supply(factory, from:)
      if metal_bars_carried?
          if ! connected_to_facility?
            engage factory
          end
        else
          if ! connected_to_facility?
            engage from
          end
        end
    end
  end

  TrackedBot.class_eval { include TrackedBotExtensions }
  PewPew.class_eval { include PewPewExtentions }
  Engineer.class_eval { include EngineerExtentions }

  class AI
    attr_accessor :player

    def initialize(player)
      self.player = player
    end

    def my_bots
      GeekGame.game_objects.bots.select { |bot| bot.player == player }
    end

    def my_engineers
      my_bots.select { |bot| bot.is_a?(Engineer) }
    end

    def my_pew_pews
      my_bots.select { |bot| bot.is_a?(PewPew) }
    end

    def my_factories
      GeekGame.game_objects.factories.select { |bot| bot.player == player }
    end

    def my_pew_pew_factory
      my_factories.find { |factory| factory.is_a? PewPewFactory }
    end

    def my_engineer_factory
      my_factories.find { |factory| factory.is_a? EngineerFactory }
    end

    def closest_metal_derrick
      GeekGame.game_objects.metal_derricks.sort { |left, right| my_pew_pew_factory.distance_to(left) <=> my_pew_pew_factory.distance_to(right) }.first
    end

    def enemy_bots
      GeekGame.game_objects.bots - my_bots
    end

    def act!(seconds)
      my_pew_pews.each do |bot|
        target = enemy_bots.sort { |left, right| bot.distance_to(left) <=> bot.distance_to(right) }.first
        return if target.nil?

        if bot.battery.charge < 0.2
          bot.advance_to(player.recharger)
        else
          bot.engage(target)
          bot.shoot(target)
        end
      end

      my_engineers.each_slice(4) do |group|
        first_bot_target = my_engineers.size < 6 ? my_engineer_factory : my_pew_pew_factory
        group.first.supply first_bot_target, from: closest_metal_derrick
        group.slice(1..3).each do |engineer|
          engineer.supply my_pew_pew_factory, from: closest_metal_derrick
        end
      end
    end
  end
end
