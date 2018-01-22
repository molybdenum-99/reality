module Reality
  class Observation
    attr_reader :entity_id, :label, :value, :time, :source

    def initialize(entity_id, label, value, source:, time: nil)
      @entity_id = entity_id
      @label = label
      @value = value
      @time = time
      @source = source
    end

    def inspect
      if timed?
        '#<%s(%s) %s=%s (%s)>' % [self.class.name, source, label, value, time.strftime('%Y-%m-%d at %H:%M:%S')]
      else
        '#<%s(%s) %s=%s>' % [self.class.name, source, label, value]
      end
    end

    def to_s
      '%s=%p' % [label, value]
    end

    def ==(other)
      other.is_a?(Observation) && label == other.label && value == other.value &&
        time == other.time
    end

    def timed?
      !time.nil?
    end
  end
end
