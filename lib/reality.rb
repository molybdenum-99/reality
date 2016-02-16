require 'infoboxer'
require 'yaml'

module Reality
  require_relative 'config'

  def self.require_(*modules)
    modules.flatten.each do |mod|
      require File.expand_path("../reality/#{mod}", __FILE__)
    end
  end

  # basic functionality
  require_ %w[refinements measure geo util/parsers]

  # engines
  require_ %w[infoboxer_templates wikidata]

  def self.wp
    @wp ||= Infoboxer.wp # while Infoboxer recreates wp for each request
  end

  # entities
  require_ %w[entity]
  require_ %w[entities/country entities/city]

  def self.entity(name, entity_class = nil)
    Entity.load(name, entity_class)
  end

  def self.country(name)
    entity(name, Country)
  end

  def self.city(name)
    entity(name, City)
  end

  require_ %w[lists]

  extend Lists

  # extras
  require_ %w[extras/open_weather_map]
  include Extras::OpenWeatherMap
end
