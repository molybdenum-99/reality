module Reality
  class Variable
    using Refinements
    attr_reader :name, :observations

    def initialize(name, observations = [])
      @name = name
      @observations = observations
    end

    def before(timestamp)
      select { |o| o.timestamp <= timestamp }
    end

    def after(timestamp)
      select { |o| o.timestamp > timestamp }
    end

    def from(source)
      select { |o| o.source == source }
    end

    def at(timestamp)
      before(timestamp).derp { |prev| prev && prev.observations.last }
    end

    def current
      at(Time.now) # FIXME: Time.now vs Date.today, comparison of Time with Date failed
                   # ...which raises a global question about timestamps coercion
    end

    def timestamps
      observations.map(&:timestamp)
    end

    def update(other)
      other.is_a?(Variable) && other.name == name or fail ArgumentError, "Can't update variable with #{other.inspect}"
      @observations.concat(other.observations)
      @observations.sort_by!(&:timestamp)
    end

    def inspect
      '#<%s %s (%s - %s): %s>' %
        [self.class.name, name, timestamps.min, timestamps.max, current]
    end

    def to_s
      current.to_s
    end

    def ==(other)
      # TODO: what about cases like if Kharkiv.population == Measure[:people](10_000)?
      other.is_a?(Variable) && other.name == name && other.observations == observations
    end

    private

    def select(&condition)
      observations.select(&condition).derp { |obs| obs.empty? ? nil : new(name, obs) }
    end

    def new(nm, obs)
      self.class.new(nm, obs)
    end
  end
end
