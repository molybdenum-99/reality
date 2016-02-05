require 'infoboxer'
require 'yaml'

module Reality
  require_relative 'config'
  require_relative 'reality/'
  require_relative 'reality/refinements'

  def self.require_(*modules)
    modules.each do |mod|
      require_relative "reality/#{mod}"
    end
  end

  # basic functionality
  require_ *%w[measure geo util/parsers]

  # engines
  require_ *%w[infoboxer_templates wikidata]

  # entities
  require_ *%w[entity] # country city]
  require_ *%w[entities/country]

  # mixins
  #require_ *%w[weather]
end
