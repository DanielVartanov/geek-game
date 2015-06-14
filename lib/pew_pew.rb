module GeekGame
  class PewPew < TrackedBot
    define_properties :gun_reload_time, :shooting_cost

    tracked_bot_properties max_velocity: 70.0, axis_length: 50.0, max_health_points: 100.0, movement_cost: 0.025
    pew_pew_properties gun_reload_time: 0.5, shooting_cost: 0.1

    attr_reader :gun, :shells

    def initialize(initial_params = {})
      super

      self.gun = Gun.new self, initial_params[:gun_relative_angle] || 90.degrees
      self.last_shoot_time = Time.now - gun_reload_time
    end

    def update(seconds)
      super
      gun.update_angle(seconds)
    end

    def fire!
      return unless (Time.now - self.last_shoot_time) > gun_reload_time
      return if battery.charge < shooting_cost

      Shell.new(angle: gun.absolute_angle, position: position, owner: self)
      battery.discharge_by(shooting_cost)

      self.last_shoot_time = Time.now
    end

    def to_hash
      super.merge gun: gun.to_hash
    end

    protected

    attr_accessor :last_shoot_time
    attr_writer :gun, :shells
  end
end
