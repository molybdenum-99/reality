module Reality
  # @private
  module City
    extend Entity::WikipediaType

    infobox_name 'Infobox settlement',
                 'Infobox city Japan',
                 'Infobox Russian city', 'Infobox Russian town',
                    'Infobox Russian inhabited locality', 
                    'Infobox Russian federal subject'

    infobox 'name', :long_name, :string

    infobox 'area_km2', :area, :measure, unit: 'km²'
    infobox 'area_total_km2', :area, :measure, unit: 'km²'

    infobox 'population_total', :population, :measure, unit: 'person'
    infobox 'population_metro', :population_metro, :measure, unit: 'person'
  end
end
