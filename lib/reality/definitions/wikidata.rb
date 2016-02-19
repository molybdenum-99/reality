module Reality
  Entity::WikidataProperties.define do
    # Geography --------------------------------------------------------
    property 'P625', :coord, :coord

    property 'P30', :continent, :entity
    property 'P17', :country, :entity

    property 'P36', :capital, :entity

    property 'P47', :neighbours, [:entity]

    property 'P2046', :area, :measure, unit: 'km²'

    # Economy and socilogy ---------------------------------------------
    property 'P38', :currency, :entity
    property 'P463', :organizations, [:entity]
    property 'P2131', :gdp_nominal, :measure, unit: '$'
    property 'P1082',:population, :measure, unit: 'person'

    # References -------------------------------------------------------
    property 'P297', :iso2_code, :string
    property 'P298', :iso3_code, :string
    property 'P78', :tld, :string
    property 'P474', :calling_code, :string
    property 'P421', :utc_offset, :utc_offset
  end
end
