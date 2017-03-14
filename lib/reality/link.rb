module Reality
  class Link
    attr_reader :source, :id
    
    def initialize(source, id)
      @source = source
      @id = id
    end

    def inspect
      '#<%s %s:%s>' % [self.class, source, id]
    end

    def to_s
      '%s:%s' % [source, id]
    end

    def ==(other)
      other.is_a?(Link) && other.source == source && other.id == id
    end
  end
end
