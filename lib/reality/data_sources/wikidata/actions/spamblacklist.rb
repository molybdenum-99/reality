# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Validate one or more URLs against the SpamBlacklist.
    #
    # Usage:
    #
    # ```ruby
    # api.spamblacklist.url(value).perform # returns string with raw output
    # # or
    # api.spamblacklist.url(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Spamblacklist < Reality::DataSources::Wikidata::Impl::Actions::Get

      # URLs to validate against the blacklist.
      #
      # @param values [Array<String>]
      # @return [self]
      def url(*values)
        values.inject(self) { |res, val| res._url(val) }
      end

      # @private
      def _url(value)
        merge(url: value.to_s, replace: false)
      end
    end
  end
end
