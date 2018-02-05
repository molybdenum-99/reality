module Reality
  class Entity
    extend Memoist

    attr_reader :observations

    class << self
      def find(**sources)
        sources.count != 1 and
          fail ArgumentError, "Entity#find expects only one key, #{sources} received"
        sources.first.derp { |source, id| new(Reality.data_sources[source].find(id)) }
      end

      alias_method :get, :find # TODO
    end

    def initialize(observations)
      @observations = observations.compact
    end

    def [](variable)
      case variable
      when String
        @observations.detect { |o| o.variable == variable }&.value
      when Regexp
        @observations.select { |o| variable === o.variable }.map(&:value).yield_self(&Util.method(:oneify))
      else
        fail ArgumentError, "Can't fetch #{variable.inspect}"
      end
    end

    memoize def uris
      observations.map(&:entity_uri).uniq
    end

    def inspect
      "#<Reality::Entity #{uris.join(', ')}>"
    end

    def describe
      [
        inspect,
        *inspect_observations(observations)
      ].join("\n").yield_self(&Util::Description.method(:new))
    end

    def load(*srcs)
      sources
        .select { |link| srcs.include?(link.source) }   # .reject(&:loaded?) # TODO
        .map { |link| self.class.get(link.source => link.id) }
        .derp { |others| [self, *others] }.inject(&:merge)
    end

    def merge(other)
      other.is_a?(Entity) or fail ArgumentError, "Can't merge #{self} with #{other}"

      self.class.new(observations + other.observations)
    end

    private

    def inspect_observations(obs)
      var_length = obs.map(&:variable).map(&:length).max + 1
      pattern = "%#{var_length}s: %s"
      obs.map { |o| pattern % [o.variable, [o.value].flatten(1).join(', ')] }
    end
  end
end
