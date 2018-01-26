# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Returns a webapp manifest.
    #
    # Usage:
    #
    # ```ruby
    # api.webapp-manifest.perform # returns string with raw output
    # # or
    # api.webapp-manifest.response # returns output parsed and wrapped into Mash-like object
    # ```
    #
    # This action has no parameters.
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class WebappManifest < Reality::Describers::Wikidata::Impl::Actions::Get
    end
  end
end
