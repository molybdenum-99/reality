module Reality
  class Link
    attr_reader :source, :id, :title

    def initialize(source, id, title: nil)
      @source = source
      @id = id
      @title = title || id
    end

    def inspect
      if title && title != id
        '#<%s %s:%s "%s">' % [self.class, source, id, title]
      else
        '#<%s %s:%s>' % [self.class, source, id]
      end
    end

    def to_s
      if title && title != id
        '<%s:[%s] %s>' % [source, id, title]
      else
        '<%s:%s>' % [source, id]
      end
    end

    def ==(other)
      other.is_a?(Link) && other.source == source && other.id == id
    end

    alias eql? ==

    def hash
      [self.class, source, id].hash
    end

    def load
      Reality.describers[source].get(id)
    end
  end
end
