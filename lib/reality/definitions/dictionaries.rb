module Reality
  module Dictionaries
    module_function

    using Reality::Refinements

    def countries
      Entity::List.new(*countries_by_continents.keys)
    end

    CITY_SYNONYMS = [
      'City',
      'Municipality',
      'Commune', # France
    ]

    CITIES_PAGE_BY_COUNTRY =
      Hash.new{|_, name| 'List of cities in %s' % name}.
      merge(
        'United States' => 'List of United States cities by population'
      )

    def cities_by_country(name)
      page = Reality.wp.get(CITIES_PAGE_BY_COUNTRY[name]) or
              return Entity::List.new()

      page.tables.map{|t|
        t.heading_row or next []
        
        idx = t.heading_row.children.
          index{|c| c.text =~ /\bname\b/i || CITY_SYNONYMS.any?{|s| c.text.strip.start_with?(s)}} or next []
          
        t.lookup(:TableCell, index: idx).lookup(:Wikilink)
      }.flatten.
      derp{|links| Entity::Coercion.coerce(links, [:entity])}
    end

    def countries_by_continents
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
