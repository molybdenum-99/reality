require 'infoboxer'
require 'yaml'

module Reality
  require_relative 'config'
  require_relative 'reality/'
  require_relative 'reality/refinements'

  def self.require_(*modules)
    modules.flatten.each do |mod|
      require File.expand_path("../reality/#{mod}", __FILE__)
    end
  end

  # basic functionality
  require_ %w[measure geo util/parsers]

  # engines
  require_ %w[infoboxer_templates wikidata]

  # entities
  require_ %w[entity]
  require_ %w[entities/country]

  def self.entity(name, entity_class = nil)
    Entity.load(name, entity_class)
  end

  def self.country(name)
    entity(name, Country)
  end

  # mixins
  #require_ *%w[weather]
end
