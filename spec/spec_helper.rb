require 'rspec/its'
require 'reality'

require 'vcr'
require 'webmock/rspec'
require 'dotenv/load'
require 'timecop'
require 'saharspec'
#require 'saharspec/string_ext'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

# Reality.configure(:demo)

#require_relative 'helpers/formatters'

#RSpec.configure do |c|
  #c.before(:suite) do
    #VCR.use_cassette('en-wikipedia-metadata') do
      #Infoboxer.wp
      #Infoboxer.wikipedia
      #require 'reality/data_sources/media_wiki'
      #require 'reality/definitions/wikipedia'
      #Reality.wikipedia.send(:internal)
    #end
  #end
#end

# RSpec::Matchers.define :be_covered_by do |range|
#   match do |actual|
#     range.cover?(actual)
#   end

#   failure_message do |actual|
#     "expected that #{actual} would be covered by #{range}"
#   end

#   description do
#     "be covered by #{range}"
#   end
# end

# RSpec::Matchers.define :observe do |value|
#   match do |observations|
#     observations.map(&:value).include?(value)
#   end

#   failure_message do |observations|
#     "expected to include #{value.inspect} but got #{observations.map(&:value).uniq}"
#   end
# end