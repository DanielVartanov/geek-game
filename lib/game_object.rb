require 'active_support/inflector'
require 'active_support/core_ext/module/delegation'

module GeekGame
  class GameObject < Struct.new(:player, :position, :angle)
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

    def to_hash
      {
        :id => id,
        :type => self.class.to_s.demodulize.underscore,
        :position => position.to_array,
        :angle => angle
      }
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

    attr_writer :birth_time

    def register!
      GeekGame.game_objects << self
    end
  end
end
