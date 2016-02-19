require 'infoboxer'
require 'yaml'

module Reality
  require_relative 'config'

  def self.require_(*modules)
    modules.flatten.flat_map{|pattern|
      Dir[File.expand_path("../reality/#{pattern}.rb", __FILE__)]
    }.each(&Kernel.method(:require))
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
  #require_ %w[entities/country entities/city]
  require_ %w[definitions/*]

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
  require_ %w[extras/open_weather_map extras/geonames]
  include Extras::OpenWeatherMap
  include Extras::Geonames
end
