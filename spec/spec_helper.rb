require 'rspec/its'
require 'reality'

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

Reality.configure(:demo)

#require_relative 'helpers/formatters'

RSpec.configure do |c|
  c.before(:suite) do
    VCR.use_cassette('en-wikipedia-metadata') do
      Infoboxer.wp
      Infoboxer.wikipedia
    end
  end
end

# I officially hate you now, Hashie.
Hashie::Mash.instance_variable_set('@disable_warnings', true)
