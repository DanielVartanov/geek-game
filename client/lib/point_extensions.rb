module GeekGame
  module PointExtensions
    def to_screen(screen)
      center = screen.size.map { |axis| axis / 2 }
      [center[0] + x, center[1] - y]
    end
  end
end

Point.class_eval { include GeekGame::PointExtensions }
