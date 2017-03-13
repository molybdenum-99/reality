module Reality
  class Entity
    attr_reader :observations
    
    def initialize(observations)
      @observations = observations
    end

    def [](name)
      @observations.select { |o| o.name == name }
    end
  end
end
