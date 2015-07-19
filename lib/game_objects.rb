module GeekGame
  class GameObjects < Scope
    # TODO: store as a hash (:id index)

    define_scope :bots, proc { |game_object| game_object.is_a?(TrackedBot) }
    define_scope :shells, proc { |game_object| game_object.is_a?(Shell) }
    define_scope :factories, proc { |game_object| game_object.is_a?(Factory) }
    define_scope :rechargers, proc { |game_object| game_object.is_a?(Recharger) }
    define_scope :metal_derricks, proc { |game_object| game_object.is_a?(MetalDerrick) }
    define_scope :connections, proc { |game_object| game_object.is_a?(Connection) }

    def update(seconds)
      each { |game_object| game_object.update(seconds) }
    end

    def all
      self
    end

    def to_hashes
      { :game_objects => self.each.map(&:to_hash) }
    end
  end

  def self.game_objects
    @game_objects ||= GameObjects.new
  end

  def self.reset!
    @game_objects = nil
  end
end
