module GeekGame
  class Client < Struct.new(:host, :port)
    def initialize(host, port)
      super(host, port)

      setup_screen
      setup_event_queue
      setup_clock
      setup_ttf
    end

    def start!
      @socket = TCPSocket.open host, port
      
      loop do
        handle_local_events
        
        @clock.tick
        
        fresh_data = @socket.gets
        update_with fresh_data
        
        draw_scene
      end
    end

    def update_with(data)
      game_objects = Parse.run data
      
      ids_to_destroy = [game_object_images.keys - game_objects.keys]
      ids_to_destroy.each do |id|
        game_object_images[id].destroy!
      end
      
      ids_to_create = [game_objects.keys - game_object_images.keys]
      ids_to_create.each do |id|
        GameObjectImage.create_from game_objects[id]
      end

      game_objects.each do |remote_object|
        game_object_images[game_object.id].merge!(remote_object)
      end
    end

    def handle_local_events
      @event_queue.each do |event|
        case event
        when Rubygame::Events::QuitRequested
          Rubygame.quit
          exit
        end
      end
    end

    def draw_scene
      @screen.fill(:black)

      game_object_images.bots.each { |bot| Graphics::TrackedBot.new(bot, @screen).draw }
      game_object_images.shells.each { |shell| Graphics::Shell.new(shell, @screen).draw }
      game_object_images.factories.each { |factory| Graphics::Factory.new(factory, @screen).draw }
      game_object_images.rechargers.each { |recharger| Graphics::Recharger.new(recharger, @screen).draw }

      text = "Game has begun"
      @screen.draw_text_info(@font, text)

      @screen.flip
    end  
  end

  protected

  def setup_ttf
    Rubygame::TTF.setup
    point_size = 12
    @font = Rubygame::TTF.new "/Library/Fonts/Courier New Bold.ttf", point_size
  end

  def setup_screen
    @screen = Rubygame::Screen.new [1280, 800], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @screen.title = "GeekGame"
    
    class << @screen
      include Shapes
      include HUD

      def default_color
        [0xff, 0xff, 00]
      end
    end
  end

  def setup_clock
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 50
    @clock.calibrate
    @clock.enable_tick_events
  end

  def setup_event_queue
    @event_queue = Rubygame::EventEvent_Queue.new
    @event_queue.enable_new_style_events
  end
end
