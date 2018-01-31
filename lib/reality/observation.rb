module Reality
  class Observation
    attr_reader :entity_uri, :variable, :value, :time, :source

    def initialize(entity_uri, variable, value, source: nil, time: nil)
      @entity_uri = entity_uri
      @variable = variable
      @value = value
      @time = time
      @source = source
    end

    def inspect
      if timed?
        '#<%s %s=%s (%s)>' % [self.class.name, variable, value, time.strftime('%Y-%m-%d at %H:%M:%S')]
      else
        '#<%s[%s] %s=%s>' % [self.class.name, entity_uri, variable, value]
      end
    end

    def to_s
      '%s=%p' % [variable, value]
    end

    def ==(other)
      other.is_a?(Observation) && variable == other.variable && value == other.value &&
        time == other.time
    end

    def timed?
      !time.nil?
    end
  end
end
