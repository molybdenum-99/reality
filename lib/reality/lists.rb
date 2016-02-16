module Reality
  module Lists
    def countries
      EntityList.new(*by_continents.keys)
    end

    private

    def by_continents
      @by_continents ||= Reality.wp.
        get('List of countries by continent').
        sections.first.
        sections.map{|s|
          continent = s.heading.text_
          s.tables.first.
            lookup(:Wikilink, :bold?).map(&:link).
            map{|country| [country, continent]}
        }.flatten(1).
        reject{|country, continent| country == 'Holy See'}. # it has [Vatican City]/[Holy See]
        to_h
    end    
  end
end
