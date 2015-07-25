module GeekGame
  module PointExtensions
    def to_screen(screen)
      screen.point_to_screen_coordinates(self)
    end

    def shift_by(x, y)
      dup.shift_by!(x, y)
    end

    def shift_by!(x, y)
      self.x += x
      self.y += y
      self
    end
  end
end

Point.class_eval { include GeekGame::PointExtensions }
