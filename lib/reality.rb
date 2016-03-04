require 'infoboxer'
require 'yaml'

module Reality
  def self.require_(*modules)
    modules.flatten.flat_map{|pattern|
      Dir[File.expand_path("../reality/#{pattern}.rb", __FILE__)]
    }.each(&Kernel.method(:require))
  end

  # basic functionality
  require_ %w[version refinements config measure geo tz_offset]
  require_ %w[util/parsers util/formatters]

  # engines
  require_ %w[infoboxer_templates wikidata]
  Infoboxer.user_agent = "Reality/#{VERSION} (https://github.com/molybdenum-99/reality; zverok.offline@gmail.com)"

  # entities
  require_ %w[entity list]
  require_ %w[definitions/*]
  require_ %w[methods]

  extend Methods

  def self.reload!
    require_ %w[definitions/*]
  end

  # extras
  require_ %w[extras/open_weather_map extras/geonames extras/economic]
  include Extras::OpenWeatherMap
  include Extras::Geonames
  include Extras::Economic
end
