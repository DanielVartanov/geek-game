require 'active_support'

module GeekGame
  class Server
    def initialize
      @queue = Rubygame::EventQueue.new
      @queue.enable_new_style_events

      @clock = Rubygame::Clock.new
      @clock.target_framerate = 100
      @clock.calibrate
      @clock.enable_tick_events

      2.times { GeekGame.game_objects << create_bot }
    end

    def run
      loop do
        seconds = @clock.tick.seconds
        update(seconds)
        handle_events
      end
    end

    def create_bot
      returning TrackedBot.new(:position => Point[50 * rand, 50 * rand], :angle => 180.degrees * rand) do |bot|
        bot.motor!(rand * 2 - 1, rand * 2 - 1)
      end
    end

    def update(seconds)
      time_step = 1e-2
      
      (seconds.to_f / time_step).to_i.times do
        GeekGame.game_objects.update(time_step)
      end

      GeekGame.game_objects.update(seconds.to_f % time_step)
    end

    def handle_events
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
