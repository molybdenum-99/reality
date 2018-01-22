# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Dump of CirrusSearch configuration.
    #
    # Usage:
    #
    # ```ruby
    # api.cirrus-config-dump.perform # returns string with raw output
    # # or
    # api.cirrus-config-dump.response # returns output parsed and wrapped into Mash-like object
    # ```
    #
    # This action has no parameters.
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class CirrusConfigDump < Reality::DataSources::Wikidata::Impl::Actions::Get
    end
  end
end
