module GeekGame
  module AI
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
      def move_to(target)
        angle_diff = normalized_movement_vector.signed_angle_with(position.vector_to(target))
        sign = angle_diff.sign

        distance = position.distance_to(target)
        power = [[distance / 60, 1].min, 0.1].max

        if sign === 0
          motor! power, power
        elsif sign > 0
          motor! (1 - angle_diff / 180.degrees * 2) * power, power
        else
          motor! power, (1 + angle_diff / 180.degrees * 2) * power
        end
      end

      def turn_to_angle(angle)
        angle_diff = normalized_movement_vector.signed_angle_with(Vector.polar(1, angle))
        sign = angle_diff.sign

        power = [angle_diff.abs / 90.degrees, 1].min

        motor! -power * sign, power * sign
      end

      def advance_to(target, angle)
        distance = position.distance_to(target)
        if distance > 25
          move_to target
        else
          turn_to_angle angle
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
        return unless close_enough_to_shoot(target)
        (angle_to(target) - gun.absolute_angle).abs % 360.degrees < 10.degrees
      end

      def engage(target)
        move_to(target.position)
        stop! if distance_to(target) < 300
      end

      def shoot(target)
        aim(target)
        fire! if worth_fire?(target)
      end

      def take_place_in_formation(formation)
        target = formation.point_for(self)
        advance_to(target, formation.angle)
        stop! if position.distance_to(target) < 20
      end
    end

    module EngineerExtentions
      def move_to(target, hold_off_distance)
        angle_diff = normalized_movement_vector.signed_angle_with(vector_to(target))
        sign = angle_diff.sign

        distance = distance_to(target) - hold_off_distance
        power = [[distance / 30, 1].min, 0.2].max

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

    module AIHelper
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
    end

    class AI < Struct.new(:player)
      include AIHelper

      def check_if_recharging_needed(bot)
        if bot.distance_to(player.recharger) < 300
          bot.stop! if bot.battery.charge < 0.99
        else
          bot.move_to(player.recharger.position) if bot.battery.charge < 0.2
        end
      end

      def make_engineers_build_bots
        my_engineers.each_slice(4) do |group|
          first_bot_target = my_engineers.size < 4 ? my_engineer_factory : my_pew_pew_factory
          group.first.supply first_bot_target, from: closest_metal_derrick
          group.slice(1..3).each do |engineer|
            engineer.supply my_pew_pew_factory, from: closest_metal_derrick
          end

          group.each { |bot| check_if_recharging_needed(bot) }
        end
      end
    end

    module Formations
      Participation = Struct.new(:formation, :bot, :meta)

      class Formation < Struct.new(:position, :angle)
        def initialize(*args)
          super
          self.participations = []
        end

        def point_for(bot)
          if bots.include?(bot)
            calculate_point_for(bot)
          else
            pick_point_for(bot)
          end
        end

        def bots
          participations.map(&:bot)
        end

        protected

        def pick_point_for(bot)
          join(bot)
          calculate_point_for(bot)
        end

        def participation_of(bot)
          participations.find { |participation| participation.bot == bot }
        end

        attr_accessor :participations
      end

      class Semicircle < Formation
        RADIUS = 150

        def join(bot)
          angle = (-90..90).to_a.sample.degrees
          self.participations << Participation.new(self, bot, angle)
        end

        def calculate_point_for(bot)
          bot_place_angle = participation_of(bot).meta
          position.advance_by(normalized_orientation_vector.reverse.rotate(bot_place_angle) * RADIUS)
        end

        def normalized_orientation_vector
          Vector.polar(1, angle)
        end
      end
    end

    class Lemmings < AI
      def act!(seconds)
        my_pew_pews.each do |bot|
          target = enemy_bots.sort { |left, right| bot.distance_to(left) <=> bot.distance_to(right) }.first
          next if target.nil?

          bot.engage(target)
          bot.shoot(target)

          check_if_recharging_needed(bot)
        end

        make_engineers_build_bots
      end
    end

    class AttackInFormation < AI
      attr_accessor :formation

      def initialize(*args)
        super
        create_formation
      end

      def create_formation
        self.formation = Formations::Semicircle.new closest_metal_derrick.position.advance_by(Vector(-300, -300)), -135.degrees
      end

      def act!(seconds)
        formation_target = enemy_bots.sort { |left, right| formation.position.distance_to(left.position) <=> formation.position.distance_to(right.position) }.first
        enemy_derrick = (GeekGame.game_objects.metal_derricks - [closest_metal_derrick]).first
        formation_target = enemy_derrick

        if formation_target.present?
          angle_to_target = Vector(1, 0).signed_angle_with(formation.position.vector_to(formation_target.position))
          formation.angle = angle_to_target
          formation.position = formation.position.advance_by(formation.normalized_orientation_vector) if my_pew_pews.count > 10
        end

        my_pew_pews.each do |bot|
          bot.take_place_in_formation(formation)

          target = enemy_bots.sort { |left, right| bot.distance_to(left) <=> bot.distance_to(right) }.first
          bot.shoot(target) if target.present?

          check_if_recharging_needed(bot)
        end

        make_engineers_build_bots
      end
    end
  end
end
