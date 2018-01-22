# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Get a new FancyCaptcha.
    #
    # Usage:
    #
    # ```ruby
    # api.fancycaptchareload.perform # returns string with raw output
    # # or
    # api.fancycaptchareload.response # returns output parsed and wrapped into Mash-like object
    # ```
    #
    # This action has no parameters.
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Fancycaptchareload < Reality::DataSources::Wikidata::Impl::Actions::Get
    end
  end
end
