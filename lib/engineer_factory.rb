module GeekGame
  class EngineerFactory < Factory
    facility_properties connection_distance: 20
    factory_properties production_time: 5.0, bot_class: Engineer, production_cost: 5
  end
end
