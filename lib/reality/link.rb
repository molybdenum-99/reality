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
        '#<%s %s://%s (%s)>' % [self.class, pretty_source, id, title]
      else
        '#<%s %s://%s>' % [self.class, pretty_source, id]
      end
    end

    def to_s
      if title && title != id
        '<%s://%s (%s)>' % [pretty_source, id, title]
      else
        '<%s://%s>' % [pretty_source, id]
      end
    end

    def pretty_source
      known = known_source? ? '' : '?'
      "#{source}#{known}"
    end

    def known_source?
      Reality.describers.key?(source)
    end

    def ==(other)
      other.is_a?(Link) && other.source == source && other.id == id
    end

    alias eql? ==

    def hash
      [self.class, source, id].hash
    end

    def load
      known_source? or fail %{Reality describer "#{source}" is yet to be implemented}
      Reality.describers.fetch(source).get(id)
    end
  end
end
