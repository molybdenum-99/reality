module Reality
  class Entity
    attr_reader :observations
    
    def initialize(observations)
      @observations = observations
    end

    def [](name)
      @observations.select { |o| o.name == name }
    end

    def sources
      self[:_source].map(&:value)
    end

    def inspect
      "#<Reality::Entity #{sources.join(', ')}>"
    end
  end
end
