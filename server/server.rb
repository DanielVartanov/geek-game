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

      @objects = Objects.new([])
    end

    def run
      loop do
        seconds = @clock.tick.seconds
        time_step = 1e-3
        (seconds.to_f / time_step).to_i.times do
          objects.bots.each { |bot| bot.update(time_step) }
        end
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
