module Reality
  class Country < Entity
    using Reality::Refinements

    property :long_name, wikipedia: 'conventional_long_name'

    property :tld, wikidata: 'P78'

    property :population, wikidata: 'P1082',
              type: :measure, unit: 'person'

    property :area, wikidata: 'P2046',
              type: :measure, unit: 'km²'
  end
end
