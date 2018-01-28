module Reality
  class Query
    attr_reader :source, :params

    def initialize(source, params = {})
      @source = source
      @params = params
    end

    def inspect
      '#<%s[%s] %p>' % [self.class, source, params]
    end

    def to_s
      '<%s:%p>' % [source, params]
    end

    def load
      Reality.describers.fetch(source).perform_query(params)
    end
  end
end
