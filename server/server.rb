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

      @red = AI.new([create_bot])
      @blue = AI.new([create_bot])
    end

    def run
      loop do
        seconds = @clock.tick.seconds
        update(seconds)
        handle_events
      end
    end

    def create_bot
      TrackedBot.new(:position => Point[300 * rand * (rand - 0.5).sign, 300 * rand * (rand - 0.5).sign], :angle => 180.degrees * rand)
    end

    def update(seconds)
      time_step = 1e-2
      
      (seconds.to_f / time_step).to_i.times do
        update_objects(time_step)
      end

      update_objects(seconds.to_f % time_step)
    end

    def update_objects(seconds)
      @red.act!(seconds)
      @blue.act!(seconds)

      GeekGame.game_objects.update(seconds)

      GeekGame.game_objects.shells.each do |shell|
        GeekGame.game_objects.bots.each do |bot|
          if bot != shell.owner and shell.hit?(bot)
            bot.take_damage(shell.damage)
            shell.die!
          end
        end
      end
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
