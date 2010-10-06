module GeekGame
  class Factory < GameObject
    PRODUCTION_TIME = 5
    
    attr_reader :position, :orientation, :player, :production_start_time

    def initialize(options)
      self.position = options[:position]
      self.orientation = options[:orientation]
      self.player = options[:player]
      self.producing = false

      super()
    end    

    def produce!
      return if producing?

      self.producing = true
      self.production_start_time = Time.now
    end

    def update(seconds)
      if producing? and production_time_passed?
        create_bot
        self.producing = false
      end      
    end

    def orientation_vector
      Vector(1, 0).rotate(orientation)
    end

    def producing?
      self.producing
    end

    def progress
      (Time.now - production_start_time) / PRODUCTION_TIME
    end

    def production_time_passed?
      Time.now - production_start_time > PRODUCTION_TIME
    end
    
    protected

    def create_bot
      TrackedBot.new :position => self.position.advance_by(orientation_vector * 25),
        :angle => orientation - 90.degrees,
        :player => player
    end
    
    attr_writer  :position, :orientation, :player, :production_start_time
    attr_accessor :producing
  end
end
