# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Check syntax of an AbuseFilter filter.
    #
    # Usage:
    #
    # ```ruby
    # api.abusefilterchecksyntax.filter(value).perform # returns string with raw output
    # # or
    # api.abusefilterchecksyntax.filter(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Abusefilterchecksyntax < Reality::Describers::Wikidata::Impl::Actions::Get

      # The full filter text to check syntax on.
      #
      # @param value [String]
      # @return [self]
      def filter(value)
        merge(filter: value.to_s)
      end
    end
  end
end
