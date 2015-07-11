module WorldHelper
  def update(seconds)
    time_step = 1e-1

    (seconds.to_f / time_step).to_i.times do
      GeekGame.game_objects.update(time_step)
    end

    GeekGame.game_objects.update(seconds.to_f % time_step)

    GeekGame.game_objects.update(1e-15) # update state last time. Update for specs with precise timings. Otherwise they would have depend on order of game objects in the world
  end
end
