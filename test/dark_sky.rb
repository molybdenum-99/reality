require 'bundler/setup'
$LOAD_PATH.unshift 'lib'
require 'reality'
require 'reality/describers/dark_sky'
module Reality::Describers; end
require 'pp'

SECRET_KEY = '19590209ae532860d1b9b2efcbcf5dcb'

lat = ARGV[0]
lng = ARGV[1]

source = Reality::Describers::DarkSky.new(SECRET_KEY)

pp response = source.perform_query(ARGV)
pp response.first.observations
