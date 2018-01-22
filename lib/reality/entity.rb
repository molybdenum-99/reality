module Reality
  using Refinements

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

    def [](label)
      @observations.select { |o| o.label == label }
    end

    memoize def links
      observations.map { |o| Link.new(o.source, o.entity_id) }.uniq
    end

    def inspect
      "#<Reality::Entity #{links.join(', ')}>"
    end

    def describe
      [
        inspect,
        *inspect_observations(observations)
      ].join("\n")
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
      label_length = obs.map(&:label).map(&:length).max + 1
      obs.map { |o| "#{o.label.to_s.rjust(label_length)}: #{o.value}" }
    end
  end
end
