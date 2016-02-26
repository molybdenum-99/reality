module Reality
  module Dictionaries
    module_function

    def countries
      Entity::List.new(*countries_by_continents.keys)
    end

    # c.tables.first.heading_row.children.index{|c| c.text.include?('Name')}
    # c.tables.first.lookup(:TableCell, index: 0).lookup(:Wikilink)

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
