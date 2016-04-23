module Reality
  # @private
  module Country
    extend Entity::WikipediaType

    infobox_name 'Infobox country'

    infobox 'conventional_long_name', :long_name, :string
    infobox 'area_km2', :area, :measure, unit: 'km²'

    infobox 'GDP_PPP', :gdp_ppp, :measure, unit: '$',
              parse: ->(var){
                str = var.text.strip.sub(/^((Int|US)?\$|USD)/, '')
                Util::Parse.scaled_number(str)
              }

    infobox 'population_census', :population, :measure, unit: 'person'
    infobox 'population_estimate', :population, :measure, unit: 'person'

    def cities
      @cities ||= Dictionaries.cities_by_country(name)
    end
  end
end
