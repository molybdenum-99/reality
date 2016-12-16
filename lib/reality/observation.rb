module Reality
  class Observation
    attr_reader :timestamp, :value, :source

    def initialize(timestamp, value, source: nil)
      @timestamp = timestamp
      @value = value
      @source = source
    end

    def ==(other)
      if other.is_a?(Observation)
        timestamp == other.timestamp && value == other.value && source == other.source
      else
        value == other
      end
    end

    def inspect
      "#<#{self.class} #{timestamp} - #{value}" +
        (source ? " (#{source})" : '') +
        '>'
    end

    def to_s
      value.to_s
    end

    def method_missing(m, *a)
      Observation.new(
        coerce_timestamps(self, *a),
        value.send(m, *a.map(&method(:coerce))),
        source: coerce_sources(self, *a)
      )
    end

    private

    def coerce(val)
      val.is_a?(Observation) ? val.value : val
    end

    def coerce_sources(*observations)
      candidates = observations.grep(Observation).map(&:source).uniq
      candidates.count == 1 ? candidates.first : nil
    end

    def coerce_timestamps(*observations)
      observations.grep(Observation).map(&:timestamp).min
    end
  end
end
