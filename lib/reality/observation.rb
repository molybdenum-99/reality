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

    def inspect
      "#<#{self.class}(#{type}): #{index} - " +
        @data.map { |k, v| "#{k}: #{v.inspect}" }.join(', ') + '>'
    end
  end
end
