module Reality
  class Entity
    attr_reader :observations
    
    def initialize(observations)
      @observations = observations.compact
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

    def describe
      [
        inspect,
        *inspect_observations(observations.reject { |o| o.name.to_s.start_with?('_') })
      ].join("\n")
    end

    private

    def inspect_observations(obs)
      name_length = obs.map(&:name).map(&:length).max + 1
      obs.map { |o| "#{o.name.to_s.rjust(name_length)}: #{o.value}" }
    end
  end
end
