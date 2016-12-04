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

RSpec::Matchers.define :send_message do |object, message|
  match do |block|
    allow(object).to receive(message)
      .tap { |m| m.with(*@with) if @with }
      .tap { |m| m.and_return(*@return) if @return }
      .tap { |m| m.and_call_original if @call_original }

    block.call

    expect(object).to have_received(message)
      .tap { |m| m.with(*@with) if @with }
  end

  chain :with do |*with|
    @with = with
  end

  chain :returning do |returning|
    @return = returning
  end

  chain :calling_original do
    @call_original = true
  end

  supports_block_expectations
end

module RSpec
  module Its
    def its_call(*options, &block)
      describe("call") do
        let(:__call_subject) do
          -> { subject }
        end

        def is_expected
          expect(__call_subject)
        end

        example(nil, *options, &block)
      end
      # rubocop:enable Lint/NestedMethodDefinition
    end
  end
end
