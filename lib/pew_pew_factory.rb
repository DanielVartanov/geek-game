module GeekGame
  class PewPewFactory < Factory
    facility_properties connection_distance: 30
    factory_properties production_time: 5.0, bot_class: PewPew, production_cost: 15
  end
end
