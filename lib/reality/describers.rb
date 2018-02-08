module Reality
  class << self
    extend Memoist

    # FIXME: Or something ¯\_(ツ)_/¯
    # Like proper "registering" themselves and blah blah
    memoize def describers
      {}
    end

    def wikipedia
      describers['wikipedia']
    end

    def open_street_map
      describers['openstreetmap']
    end

    alias openstreetmap open_street_map
    alias osm open_street_map

    def wikidata
      describers['wikidata']
    end

    def commons
      describers['wikimedia-commons']
    end

    def open_weather_map
      describers['open_weather_map']
    end
  end
end
