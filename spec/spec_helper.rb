require 'rspec/its'
require 'reality'
require 'pp'

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

Reality.configure(:demo)

#require_relative 'helpers/formatters'

require 'dotenv'
Dotenv.load

module EntityIntegrationHelper
  def self.included(group)
    group.before(:all){
      # reloading them back for "integrational" tests
      load './lib/reality/definitions/wikidata/predicates.rb'
      load './lib/reality/definitions/mediawiki/en.wikipedia.org.rb'
      load './lib/reality/modules/simple.rb'

      # Only once for entire group: faster parsing
      VCR.use_cassette(group.metadata[:entity]){
        @entity = Reality::Entity(group.metadata[:entity])
      }
    }
    group.subject(:entity) { @entity }
  end
end

RSpec.configure do |c|
  c.before(:suite) do
    VCR.use_cassette('en-wikipedia-metadata') do
      Infoboxer.wp
      Infoboxer.wikipedia
    end
  end

  c.before do |example|
    unless example.metadata[:integrational]
      Reality::Modules.list.clear
      Reality::Definitions::MediaWiki.clear
    end
  end

  c.include EntityIntegrationHelper, integrational: true
end
