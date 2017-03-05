module Reality
  class Observation
    attr_reader :name, :value
    
    def initialize(name, value)
      @name = name
      @value = value
    end

    def inspect
      '#<%s %s=%s>' % [self.class.name, name, value]
    end
  end
end
