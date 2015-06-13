module GeekGame
  class Battery
    MAX_CHARGE = 1

    attr_reader :charge

    def initialize
      self.charge = MAX_CHARGE
    end

    def discharge_by(amount)
      self.charge -= amount
      self.charge = [0, charge].max
    end

    def charge_by(amount)
      self.charge += amount
      self.charge = [MAX_CHARGE, charge].min
    end

    def to_hash
      { charge: charge }
    end

    protected

    attr_writer :charge
  end
end
