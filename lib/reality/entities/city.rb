module Reality
  module City
    using Reality::Refinements

    extend EntityClass

    by_infobox 'Infobox settlement'

    property :long_name, wikipedia: 'name'

    property :utc_offset, wikidata: 'P421', type: :utc_offset
    property :coord, wikidata: 'P625', type: :coord

    property :area, wikipedia: 'area_total_km2',
      type: :measure, unit: 'km²'

    property :population, wikipedia: 'population_total',
      type: :measure, unit: 'person'
    property :population_metro, wikipedia: 'population_metro',
      type: :measure, unit: 'person'

    property :country, wikidata: 'P17', type: :entity
  end
end
