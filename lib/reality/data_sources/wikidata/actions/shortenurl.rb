# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Shorten a long URL into a shorter one.
    #
    # Usage:
    #
    # ```ruby
    # api.shortenurl.url(value).perform # returns string with raw output
    # # or
    # api.shortenurl.url(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Shortenurl < Reality::DataSources::Wikidata::Impl::Actions::Post

      # URL to be shortened.
      #
      # @param value [String]
      # @return [self]
      def url(value)
        merge(url: value.to_s)
      end
    end
  end
end
