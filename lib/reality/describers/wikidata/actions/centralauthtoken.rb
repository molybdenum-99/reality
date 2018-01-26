# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Fetch a centralauthtoken for making an authenticated request to an attached wiki.
    #
    # Usage:
    #
    # ```ruby
    # api.centralauthtoken.perform # returns string with raw output
    # # or
    # api.centralauthtoken.response # returns output parsed and wrapped into Mash-like object
    # ```
    #
    # This action has no parameters.
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Centralauthtoken < Reality::Describers::Wikidata::Impl::Actions::Get
    end
  end
end
