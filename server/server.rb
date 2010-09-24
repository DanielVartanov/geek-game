require 'active_support'

module GeekGame
  Objects = Struct.new(:bots)

  class Server
    attr_reader :objects
    
    def initialize
      @queue = Rubygame::EventQueue.new
      @queue.enable_new_style_events

      @clock = Rubygame::Clock.new
      @clock.target_framerate = 100
      @clock.calibrate
      @clock.enable_tick_events

      # Bot

      bots = []
      20.times { bots << create_bot } 
      @objects = Objects.new(bots)
    end

    def run
      loop do
        seconds = @clock.tick.seconds
        time_step = 1e-2
        (seconds.to_f / time_step).to_i.times do
          objects.bots.each { |bot| bot.update }
        end
        update
      end
    end

    def create_bot
      returning TrackedBot.new(:position => Point[50 * rand, 50 * rand], :angle => 180.degrees * rand) do |bot|
        bot.motor!(rand * 2 - 1, rand * 2 - 1)
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
