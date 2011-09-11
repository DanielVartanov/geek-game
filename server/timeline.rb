require 'active_support'

module GeekGame
  class Timeline
    def initialize
      setup_event_queue
      setup_clock
      setup_world
      
      @ai = [AI.new(@red), AI.new(@blue)]
    end

    def start!
      loop do
        handle_system_events
        seconds_passed = @clock.tick.seconds
        gradually_update(seconds_passed)
      end
    end

    def gradually_update(seconds_passed)
      time_step = 1e-1
      
      (seconds_passed.to_f / time_step).to_i.times do
        update_game_world(time_step)
      end

      update_game_world(seconds_passed.to_f % time_step)
    end

    def update_game_world(seconds_passed)
      @ai.each { |ai| ai.act!(seconds) } # TODO: to be wiped out to client (AI) side

      @world.update(seconds_passed)
    end

    def handle_system_events
      @event_queue.each do |event|
        case event
        when Rubygame::Events::QuitRequested
          Rubygame.quit
          exit
        end
      end
    end

    protected

    def setup_event_queue
      @event_queue = Rubygame::EventEvent_Queue.new
      @event_queue.enable_new_style_events
    end

    def setup_clock
      @clock = Rubygame::Clock.new
      @clock.target_framerate = 10
      @clock.calibrate
      @clock.enable_tick_events
    end

    def setup_world
      @world = GeekGame::World.new
    end
  end
end
