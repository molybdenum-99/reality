module Reality
  Entity::WikidataPredicates.define do
    # Generic relations ------------------------------------------------
    predicate 'P361', :part_of, [:entity]

    # Object features --------------------------------------------------
    predicate 'P2048', :height, :measure, unit: 'm'
    
    # Geography --------------------------------------------------------
    predicate 'P625', :coord, :coord

    predicate 'P30' , :continent, :entity
    predicate 'P17' , :country, :entity
    predicate 'P610', :highest_point, :entity

    predicate 'P36' , :capital, :entity
    predicate 'P150', :adm_divisions, [:entity]

    predicate 'P47' , :neighbours, [:entity]

    predicate 'P2046', :area, :measure, unit: 'km²'
    predicate 'P2044', :elevation, :measure, unit: 'm'

    # Economy and socilogy ---------------------------------------------
    predicate 'P38', :currency, :entity
    predicate 'P463', :organizations, [:entity]
    predicate 'P2131', :gdp_nominal, :measure, unit: '$'
    predicate 'P1082',:population, :measure, unit: 'person'

    predicate 'P35', :head_of_state, :entity

    # References -------------------------------------------------------
    predicate 'P297', :iso2_code, :string
    predicate 'P298', :iso3_code, :string
    predicate 'P78', :tld, :string
    predicate 'P474', :calling_code, :string
    predicate 'P421', :utc_offset, :utc_offset

    # People -----------------------------------------------------------
    # personal
    predicate 'P19', :birth_place, :entity
    predicate 'P569', :birthday, :datetime
    predicate 'P570', :date_of_death, :datetime
    predicate 'P20', :place_of_death, :entity
    predicate 'P21', :sex, :string
    predicate 'P735', :given_name, :string

    # family
    predicate 'P26', :spouse, :entity
    predicate 'P40', :children, [:entity]
    predicate 'P22', :father, :entity

    # social
    predicate 'P551', :residence, :entity
    predicate 'P27', :citizenship, :entity
    predicate 'P39', :position, :string
    predicate 'P106', :occupations, [:string]
  end
end
