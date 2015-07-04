require 'active_support/inflector'
require 'active_support/core_ext/module/delegation'

module GeekGame
  class GameObject
    attr_reader :position
    attr_reader :birth_time

    def initialize
      register!
      self.birth_time = Time.now
    end

    def die!
      GeekGame.game_objects.delete(self)
    end

    def life_time
      Time.now - birth_time
    end

    def vector_to(another_object)
      Vector.by_end_points(position, another_object.position)
    end

    def distance_to(another_object)
      position.distance_to(another_object.position)
    end

    def to_hash
      {
        id: id,
        type: self.class.to_s.demodulize.underscore,
        position: position.to_array
      }.tap do |hash|
        hash[:player_color] = player.color if respond_to?(:player) && player
        hash[:angle] = angle if respond_to?(:angle)
      end
    end

    alias :id :object_id

    class << self
      def define_properties(*properties)
        delegate *properties, to: 'self.class'.to_sym

        class_name = name.demodulize.underscore
        singleton_class.instance_eval do
          properties.each { |property| attr_reader property }

          define_method "#{class_name}_properties" do |values|
            values.each_pair do |key, value|
              instance_variable_set "@#{key}".to_sym, value
            end
          end
        end
      end
    end

    protected

    attr_writer :position
    attr_writer :birth_time

    def register!
      GeekGame.game_objects << self
    end
  end
end
