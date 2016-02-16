module Reality
  module Country
    using Reality::Refinements

    extend EntityClass

    by_infobox 'Infobox country'

    property :long_name, wikipedia: 'conventional_long_name'

    property :iso2_code, wikidata: 'P297'
    property :iso3_code, wikidata: 'P298'
    property :tld, wikidata: 'P78'
    property :calling_code, wikidata: 'P474'

    property :population, wikidata: 'P1082',
              type: :measure, unit: 'person'

    property :area, wikidata: 'P2046', wikipedia: 'area_km2',
              type: :measure, unit: 'km²'

    property :gdp_nominal, wikidata: 'P2131',
              type: :measure, unit: '$'
              

    property :gdp_ppp, wikipedia: 'GDP_PPP',
              type: :measure, unit: '$',
              parse: ->(var){
                str = var.text.strip.sub(/^((Int|US)?\$|USD)/, '')
                Util::Parse.scaled_number(str)
              }

    property :utc_offset, wikidata: 'P421', type: :utc_offset

    property :coord, wikidata: 'P625', type: :coord

    property :continent, wikidata: 'P30', type: :entity
    property :capital, wikidata: 'P36', type: :entity
    property :currency, wikidata: 'P38', type: :entity
    property :organizations, wikidata: 'P463', type: [:entity]
    property :neighbours, wikidata: 'P47', type: [:entity]
  end
end
