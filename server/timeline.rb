require 'active_support'

module GeekGame
  class Timeline
    def initialize
      setup_event_queue
      setup_clock
      setup_world
      setup_network_server

      # This is temporarily here
      @red = Player.new color: [0xff, 0, 0]
      MetalDerrick.new position: Point(-400, -200)
      @red.recharger = Recharger.new position: Point(-400, -200), player: @red
      PewPewFactory.new position: Point(-300, -100), angle: 45.degrees, player: @red
      EngineerFactory.new position: Point(-500, -200), angle: -135.degrees, player: @red
      build_initial_engineers_for @red

      @blue = Player.new color: [0, 0, 0xff]
      MetalDerrick.new position: Point(400, 200)
      @blue.recharger = Recharger.new position: Point(400, 200), player: @blue
      PewPewFactory.new position: Point(300, 100), angle: -135.degrees, player: @blue
      EngineerFactory.new position: Point(500, 200), angle: 45.degrees, player: @blue
      build_initial_engineers_for @blue

      @ai = [AI.new(@red), AI.new(@blue)]
    end

    def build_initial_engineers_for(player)
      3.times do
        random_position = player.recharger.position.advance_by(Vector.polar(1, rand(360).degrees) * rand(300))
        Engineer.new position: random_position, angle: rand(360).degrees, player: player
      end
    end

    def start!
      loop do
        handle_system_events
        seconds_passed = @clock.tick.seconds
        gradually_update(seconds_passed)

        @network_server.push
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
      @ai.each { |ai| ai.act!(seconds_passed) } # TODO: to be wiped out to client (AI) side

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

    def setup_network_server
      @network_server = GeekGame::Network::Server.new self, 'localhost', 21000
      @network_server.bind_to_port
      print "Waiting for client..."
      @network_server.wait_for_client
      puts " client connected"
    end

    def setup_event_queue
      @event_queue = Rubygame::EventQueue.new
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
