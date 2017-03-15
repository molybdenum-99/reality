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
      require 'reality/data_sources/media_wiki'
      require 'reality/definitions/wikipedia'
      Reality.wikipedia.send(:internal)
    end
  end
end

# I officially hate you now, Hashie.
Hashie::Mash.instance_variable_set('@disable_warnings', true)

class String
  # allows to pretty test agains multiline strings:
  #   %Q{
  #     |test
  #     |me
  #   }.unindent # =>
  # "test
  # me"
  def unindent
    gsub(/\n\s+?\|/, "\n")    # for all lines looking like "<spaces>|" -- remove this.
    .gsub(/\|\n/, "\n")       # allow to write trailing space not removed by editor
    .gsub(/^\n|\n\s+$/, '')   # remove empty strings before and after
  end
end
