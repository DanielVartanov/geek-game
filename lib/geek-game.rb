module PointExtensions
  def to_screen(screen)
    center = screen.size.map { |axis| axis / 2 }
    [center[0] + x, center[1] - y]
  end
end

Point.class_eval { include PointExtensions }

class GeekGame
  def initialize
    @screen = Rubygame::Screen.new [640,480], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
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

    # Bot

    @bot = TrackedBot.new
  end
  
  def run
    loop do
      seconds = @clock.tick.seconds
      @bot.update(seconds)
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
    
    @bot.draw(@screen)

    text = "position: (#{@bot.position.x.to_i}, #{@bot.position.y.to_i}) angle: #{(@bot.angle * 180 / Math::PI).to_i} track power: [#{@bot.left_track_power}, #{@bot.right_track_power}]"

    @screen.draw_text_info(@font, text)

    @screen.flip
  end  
end
