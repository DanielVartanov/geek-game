module GeekGame
  class Recharger < GameObject
    RANGE = 900
    CHARGE_RATE = 0.1

    attr_reader :position, :player

    def initialize(params)
      self.position = params[:position]
      self.player = params[:player]

      super()
    end

    def distance_to(target)
      position.distance_to(target.position)
    end

    def update(seconds)
      GeekGame.game_objects.bots.each do |bot|
        if bot.player == player and distance_to(bot) < RANGE
          bot.battery.charge_by(CHARGE_RATE * seconds)
        end
      end
    end

    protected

    attr_writer :position, :player
  end
end
