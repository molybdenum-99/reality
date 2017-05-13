# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Returns a featured content feed.
    #
    # Usage:
    #
    # ```ruby
    # api.featuredfeed.feedformat(value).perform # returns string with raw output
    # # or
    # api.featuredfeed.feedformat(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Featuredfeed < Reality::DataSources::Wikidata::Impl::Actions::Get

      # The format of the feed.
      #
      # @param value [String] One of "rss", "atom".
      # @return [self]
      def feedformat(value)
        _feedformat(value) or fail ArgumentError, "Unknown value for feedformat: #{value}"
      end

      # @private
      def _feedformat(value)
        defined?(super) && super || ["rss", "atom"].include?(value.to_s) && merge(feedformat: value.to_s)
      end

      # Feed name.
      #
      # @param value [String] One of "".
      # @return [self]
      def feed(value)
        _feed(value) or fail ArgumentError, "Unknown value for feed: #{value}"
      end

      # @private
      def _feed(value)
        defined?(super) && super || [""].include?(value.to_s) && merge(feed: value.to_s)
      end

      # Feed language code. Ignored by some feeds.
      #
      # @param value [String]
      # @return [self]
      def language(value)
        merge(language: value.to_s)
      end
    end
  end
end
