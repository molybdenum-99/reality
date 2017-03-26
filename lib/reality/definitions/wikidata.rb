def Reality.wikidata
  @wikidata ||= Reality::DataSources::Wikidata.new
end

Reality.data_sources[:wikidata] = Reality.wikidata # FIXME: Or something ¯\_(ツ)_/¯

# Generic relations ------------------------------------------------
Reality.wikidata.predicate 'P361', :part_of, [:entity]
Reality.wikidata.predicate 'P527', :parts, [:entity] # aliases: :members

Reality.wikidata.predicate 'P155', :follows, :entity
Reality.wikidata.predicate 'P156', :precedes, :entity
Reality.wikidata.predicate 'P571', :created_at, :date # TODO: aliases: :founded_at, :incepted_at

Reality.wikidata.predicate 'P740', :location, :entity
Reality.wikidata.predicate 'P585', :date    , :date # TODO: maybe :datetime?

Reality.wikidata.predicate 'P737', :influenced_by, [:entity]

# Object features --------------------------------------------------
Reality.wikidata.predicate 'P2048', :height, :measure, unit: 'm'

# Geography --------------------------------------------------------
Reality.wikidata.predicate 'P625', :coord, :coord

Reality.wikidata.predicate 'P30' , :continent, :entity
Reality.wikidata.predicate 'P17' , :country, :entity
Reality.wikidata.predicate 'P610', :highest_point, :entity

Reality.wikidata.predicate 'P36' , :capital, :entity
Reality.wikidata.predicate 'P150', :adm_divisions, [:entity]

Reality.wikidata.predicate 'P47' , :neighbours, [:entity]

Reality.wikidata.predicate 'P2046', :area, :measure, unit: 'km²'
Reality.wikidata.predicate 'P2044', :elevation, :measure, unit: 'm'

Reality.wikidata.predicate 'P969', :street_address, :string
Reality.wikidata.predicate 'P131', :located_in, :entity

# Economy and sociology ---------------------------------------------
Reality.wikidata.predicate 'P38', :currency, :entity
Reality.wikidata.predicate 'P463', :organizations, [:entity]
Reality.wikidata.predicate 'P2131', :gdp_nominal, :measure, unit: '$'
Reality.wikidata.predicate 'P1082',:population, :measure, unit: 'person'

Reality.wikidata.predicate 'P35', :head_of_state, :entity
Reality.wikidata.predicate 'P6', :head_of_government, :entity

# References -------------------------------------------------------
Reality.wikidata.predicate 'P297', :iso2_code, :string
Reality.wikidata.predicate 'P298', :iso3_code, :string
Reality.wikidata.predicate 'P78', :tld, :string
Reality.wikidata.predicate 'P474', :calling_code, :string
Reality.wikidata.predicate 'P421', :tz_offset, :tz_offset

# People -----------------------------------------------------------
# personal
Reality.wikidata.predicate 'P19', :birth_place, :entity
Reality.wikidata.predicate 'P569', :birthday, :date
Reality.wikidata.predicate 'P570', :date_of_death, :date
Reality.wikidata.predicate 'P20', :place_of_death, :entity
Reality.wikidata.predicate 'P21', :sex, :string
Reality.wikidata.predicate 'P735', :given_name, :string

# family
Reality.wikidata.predicate 'P26', :spouse, :entity
Reality.wikidata.predicate 'P40', :children, [:entity]
Reality.wikidata.predicate 'P22', :father, :entity

# social
Reality.wikidata.predicate 'P551', :residence, :entity
Reality.wikidata.predicate 'P27', :citizenship, :entity
Reality.wikidata.predicate 'P39', :position, :string
Reality.wikidata.predicate 'P106', :occupations, [:string]

# General creative works & workers ---------------------------------
Reality.wikidata.predicate 'P577', :published_at, :date
Reality.wikidata.predicate 'P136', :genres, [:string]
Reality.wikidata.predicate 'P166', :awards, [:entity]
Reality.wikidata.predicate 'P1411', :nominations, [:entity]
Reality.wikidata.predicate 'P921', :work_subjects, [:string]
Reality.wikidata.predicate 'P364', :original_languages, [:string]

# Music album ------------------------------------------------------
Reality.wikidata.predicate 'P658', :tracks, [:string]
Reality.wikidata.predicate 'P175', :performer, :entity
#Reality.wikidata.predicate 'P175', :performers, [:entity] - TODO

# Companies --------------------------------------------------------
Reality.wikidata.predicate 'P112', :founders, [:entity]
Reality.wikidata.predicate 'P127', :owners, [:entity]
Reality.wikidata.predicate 'P169', :ceo, :entity
Reality.wikidata.predicate 'P1128', :employees_count, :measure, unit: 'person'
Reality.wikidata.predicate 'P452', :industry, :string

# Software ---------------------------------------------------------
Reality.wikidata.predicate 'P178', :developers, [:entity]
Reality.wikidata.predicate 'P275', :licenses, [:string]
Reality.wikidata.predicate 'P348', :version, :string

# Movies -----------------------------------------------------------
Reality.wikidata.predicate 'P57', :directors, [:entity]
Reality.wikidata.predicate 'P162', :producers, [:entity]
Reality.wikidata.predicate 'P161', :actors, [:entity]

# Wehicles ---------------------------------------------------------
Reality.wikidata.predicate 'P1029', :crew_members, [:entity]

# Fictional entities -----------------------------------------------
Reality.wikidata.predicate 'P1080', :fictional_universe, :string
Reality.wikidata.predicate 'P1441', :present_in_works, [:entity]

# Internet ---------------------------------------------------------
Reality.wikidata.predicate 'P856', :official_website, :string
Reality.wikidata.predicate 'P2002', :twitter_username, :string
