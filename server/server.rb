module GeekGame
  Objects = Struct.new(:bots)

  class Server
    attr_reader :objects
    
    def initialize
      @queue = Rubygame::EventQueue.new
      @queue.enable_new_style_events

      @clock = Rubygame::Clock.new
      @clock.target_framerate = 50
      @clock.calibrate
      @clock.enable_tick_events

      # Bot

      bot = TrackedBot.new
      bot.left_track.target_power = 0.7
      bot.right_track.target_power = 1

      @objects = Objects.new([bot])
    end

    def run
      loop do
        seconds = @clock.tick.seconds
        objects.bots.each { |bot| bot.update(seconds) }
        update
      end
    end

    def update
      @queue.each do |event|
        case event
        when Rubygame::Events::QuitRequested
          Rubygame.quit
          exit
        end
      end
    end
  end
end
