module Reality
  class Observation
    attr_reader :name, :value, :time

    def initialize(name, value, time: nil)
      @name = name
      @value = value
      @time = time
    end

    def inspect
      if timed?
        '#<%s %s=%s (%s)>' % [self.class.name, name, value, time.strftime('%Y-%m-%d at %H:%M:%S')]
      else
        '#<%s %s=%s>' % [self.class.name, name, value]
      end
    end

    def ==(other)
      other.is_a?(Observation) && name == other.name && value == other.value &&
        time == other.time
    end

    def timed?
      !time.nil?
    end
  end
end
