module GeekGame
  class GameObjects < Scope
    define_scope :bots, proc { |game_object| game_object.is_a?(TrackedBot) }
    define_scope :shells, proc { |game_object| game_object.is_a?(Shell) }
    define_scope :factories, proc { |game_object| game_object.is_a?(Factory) }
    define_scope :rechargers, proc { |game_object| game_object.is_a?(Recharger) }

    def update(seconds)
      each { |game_object| game_object.update(seconds) }
    end

    def all
      self
    end
  end

  def self.game_objects
    @game_objects ||= GameObjects.new
  end
end
