# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Mark translations reviewed.
    #
    # Usage:
    #
    # ```ruby
    # api.translationreview.revision(value).perform # returns string with raw output
    # # or
    # api.translationreview.revision(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Translationreview < Reality::DataSources::Wikidata::Impl::Actions::Post

      # The revision number to review.
      #
      # @param value [Integer]
      # @return [self]
      def revision(value)
        merge(revision: value.to_s)
      end

      # A "csrf" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end
    end
  end
end
