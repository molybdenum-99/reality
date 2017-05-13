# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Mark notifications as seen for the current user.
    #
    # Usage:
    #
    # ```ruby
    # api.echomarkseen.token(value).perform # returns string with raw output
    # # or
    # api.echomarkseen.token(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Echomarkseen < Reality::DataSources::Wikidata::Impl::Actions::Post

      # A "csrf" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end

      # Type of notifications to mark as seen: 'alert', 'message' or 'all'.
      #
      # @param value [String] One of "alert", "message", "all".
      # @return [self]
      def type(value)
        _type(value) or fail ArgumentError, "Unknown value for type: #{value}"
      end

      # @private
      def _type(value)
        defined?(super) && super || ["alert", "message", "all"].include?(value.to_s) && merge(type: value.to_s)
      end

      # Timestamp format to use for output, 'ISO_8601' or 'MW'.  'MW' is deprecated here, so all clients should switch to 'ISO_8601'.  This parameter will be removed, and 'ISO_8601' will become the only output format.
      #
      # @param value [String] One of "ISO_8601", "MW".
      # @return [self]
      def timestampFormat(value)
        _timestampFormat(value) or fail ArgumentError, "Unknown value for timestampFormat: #{value}"
      end

      # @private
      def _timestampFormat(value)
        defined?(super) && super || ["ISO_8601", "MW"].include?(value.to_s) && merge(timestampFormat: value.to_s)
      end
    end
  end
end
