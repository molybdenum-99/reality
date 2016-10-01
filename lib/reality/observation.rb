module Reality
  class Observation
    attr_reader :index, :type

    def initialize(_index:, _type: nil, **data)
      @index = _index
      @type = _type
      @data = data
      @data.each { |k, v| define_singleton_method(k) { v } }
    end

    def [](key)
      @data.fetch(key)
    end

    def variables
      @data.keys
    end

    def to_h
      @data.dup
    end

    def ==(other)
      other.is_a?(Observation) && index == other.index && type == other.type &&
        @data == other.to_h
    end

    def extend_variables(*variables)
      new_data = variables.map { |v| [v, nil] }.to_h.merge(@data)
      Observation.new(_index: index, _type: type, **new_data)
    end

    def inspect
      "#<#{self.class}(#{type}): #{index} - " +
        @data.map { |k, v| "#{k}: #{v.inspect}" }.join(', ') + '>'
    end
  end
end
