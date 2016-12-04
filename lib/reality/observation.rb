module Reality
  class Observation
    attr_reader :timestamp, :value, :source

    def initialize(timestamp, value, source: nil)
      @timestamp = timestamp
      @value = value
      @source = source
    end

    def ==(other)
      other.is_a?(Observation) && timestamp == other.timestamp && value == other.value && source == other.source
    end

    def inspect
      "#<#{self.class} #{timestamp} - #{value}" +
        (source ? " (#{source})" : '') +
        '>'
    end

    def to_s
      value.to_s
    end
  end
end
