# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Clears the hasmsg flag for the current user.
    #
    # Usage:
    #
    # ```ruby
    # api.clearhasmsg.perform # returns string with raw output
    # # or
    # api.clearhasmsg.response # returns output parsed and wrapped into Mash-like object
    # ```
    #
    # This action has no parameters.
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Clearhasmsg < Reality::Describers::Wikidata::Impl::Actions::Post
    end
  end
end
