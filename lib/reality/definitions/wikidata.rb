module Reality
  Entity::WikidataPredicates.define do
    # Geography --------------------------------------------------------
    predicate 'P625', :coord, :coord

    predicate 'P30', :continent, :entity
    predicate 'P17', :country, :entity

    predicate 'P36', :capital, :entity

    predicate 'P47', :neighbours, [:entity]

    predicate 'P2046', :area, :measure, unit: 'km²'

    # Economy and socilogy ---------------------------------------------
    predicate 'P38', :currency, :entity
    predicate 'P463', :organizations, [:entity]
    predicate 'P2131', :gdp_nominal, :measure, unit: '$'
    predicate 'P1082',:population, :measure, unit: 'person'

    # References -------------------------------------------------------
    predicate 'P297', :iso2_code, :string
    predicate 'P298', :iso3_code, :string
    predicate 'P78', :tld, :string
    predicate 'P474', :calling_code, :string
    predicate 'P421', :utc_offset, :utc_offset
  end
end
