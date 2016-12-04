module Reality
  class Variable
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
      before(timestamp).observations.last
    end

    def current
      at(Date.today) # FIXME: Time.now, comparison failed
    end

    def timestamps
      observations.map(&:timestamp)
    end

    def inspect
      '#<%s %s (%s - %s): %s>' %
        [self.class.name, name, timestamps.min, timestamps.max, current]
    end

    private

    def select(&condition)
      new(name, observations.select(&condition))
    end

    def new(nm, obs)
      self.class.new(nm, obs)
    end
  end
end
