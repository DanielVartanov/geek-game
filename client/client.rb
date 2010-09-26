module GeekGame
  class Client < Struct.new(:game_objects)
    def initialize(game_objects)
      @screen = Rubygame::Screen.new [1024,768], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
      @screen.title = "GeekGame"

      @queue = Rubygame::EventQueue.new
      @queue.enable_new_style_events

      @clock = Rubygame::Clock.new
      @clock.target_framerate = 50
      @clock.calibrate
      @clock.enable_tick_events

      class << @screen
        include Shapes
        include HUD

        def default_color
          [0xff, 0xff, 00]
        end
      end

      # TTF

      Rubygame::TTF.setup
      point_size = 12
      @font = Rubygame::TTF.new "/usr/share/fonts/truetype/ttf-dejavu/DejaVuSans-Bold.ttf", point_size

      super(game_objects)
    end

    def run
      loop do
        seconds = @clock.tick.seconds
        update
        draw            
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

    def draw
      @screen.fill(:black)

      game_objects.bots.each { |bot| Graphics::TrackedBot.new(bot, @screen).draw }
      game_objects.shells.each { |shell| Graphics::Shell.new(shell, @screen).draw }      

 #     text = "position: (#{@bot.position.x.to_i}, #{@bot.position.y.to_i}) angle: #{(@bot.angle * 180 / Math::PI).to_i} track power: [#{@bot.left_track.power}, #{@bot.right_track.power}]"

      text = "Hello, underworld!"
      @screen.draw_text_info(@font, text)

      @screen.flip
    end  
  end  
end
