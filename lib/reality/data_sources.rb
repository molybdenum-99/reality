module Reality
  module DataSources
    %w[base wikipedia wikidata].each { |source| require_relative "data_sources/#{source}" }

    def self.sources
      @sources ||= Hash.new { |h, k| h[k] = public_send(k) }
    end

    def self.[](source)
      sources[source]
    end
  end
end

