require 'yaml'
require 'pp'
require 'hashie'
require 'fileutils'

require 'backports/latest'
require 'memoist'
require 'hm'

require 'money'
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
  require_ %w[version config measure tz_offset date coord currency coerce]
  require_ %w[setup util util/description util/refinements util/parsers util/formatters]

  # engines
  USER_AGENT = "Reality/#{VERSION} (https://github.com/molybdenum-99/reality; zverok.offline@gmail.com)"

  # entities
  require_ %w[observation link query entity]

  # particular describers
  require_ %w[
    describers
    describers/abstract/base
    describers/abstract/media_wiki
    describers/wikipedia
    describers/wikidata
    describers/open_street_map
    describers/wikimedia_commons
    describers/open_weather_map
  ]
end
