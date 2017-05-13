# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Search for language names in any script.
    #
    # Usage:
    #
    # ```ruby
    # api.languagesearch.search(value).perform # returns string with raw output
    # # or
    # api.languagesearch.search(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Languagesearch < Reality::DataSources::Wikidata::Impl::Actions::Get

      # Search string.
      #
      # @param value [String]
      # @return [self]
      def search(value)
        merge(search: value.to_s)
      end

      # Number of spelling mistakes allowed in the search string.
      #
      # @param value [Integer]
      # @return [self]
      def typos(value)
        merge(typos: value.to_s)
      end
    end
  end
end
