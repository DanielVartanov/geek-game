module GeekGame
  class Battery
    INITIAL_CHARGE = 1

    attr_reader :charge

    def initialize
      self.charge = INITIAL_CHARGE
    end

    def discharge_by(amount)
      self.charge -= amount
      self.charge = 0 if self.charge < 0
    end

    protected

    attr_writer :charge
  end
end
