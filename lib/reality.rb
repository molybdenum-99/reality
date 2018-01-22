require 'yaml'
require 'pp'
require 'backports/2.5.0/kernel'
require 'memoist'
require 'geo/coord'
require 'tz_offset'

# Reality is library for accessing all world data, starting from Wikipedia.
#
# Look at {Entity} for good starting point.
#
# You also may want to navigate [Getting started](https://github.com/molybdenum-99/reality/wiki/Getting-started)
# page in our wiki.
module Reality
  # @private
  def self.require_(*modules)
    modules.flatten.flat_map{|pattern|
      Dir[File.expand_path("../reality/#{pattern}.rb", __FILE__)]
    }.each(&Kernel.method(:require))
  end

  # basic functionality
  require_ %w[version refinements config measure tz_offset]
  require_ %w[util/parsers util/formatters]

  # engines
  #require_ %w[infoboxer_templates]
  USER_AGENT = "Reality/#{VERSION} (https://github.com/molybdenum-99/reality; zverok.offline@gmail.com)"

  # entities
  require_ %w[observation link entity list]
  #require_ %w[definitions/*]
  #require_ %w[methods names]

  #include Methods
  #extend Methods

  # extras
  #require_ %w[extras/open_weather_map extras/geonames extras/quandl]
  #include Extras::OpenWeatherMap
  #include Extras::Geonames
  #include Extras::Quandl
end
