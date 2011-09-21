module GeekGame
  class LeftTrack < Track
    def position
      bot.right_track.position.rotate_around(bot.position, 180.degrees)
    end
  end
end
