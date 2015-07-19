module Graphics
  class PewPew < TrackedBot
    def self.track_size
      8
    end

    def axis_length
      GeekGame::PewPew.axis_length
    end

    def draw_gun
      barrel_end = position.advance_by(Vector(1, 0).rotate(gun["angle"]) * (axis_length / 2))
      surface.line(Line(position, barrel_end), [0, 0xff, 0])
    end

    def draw
      super
      draw_gun
    end
  end
end
