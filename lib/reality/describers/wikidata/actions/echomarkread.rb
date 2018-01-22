# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Mark notifications as read for the current user.
    #
    # Usage:
    #
    # ```ruby
    # api.echomarkread.list(value).perform # returns string with raw output
    # # or
    # api.echomarkread.list(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Echomarkread < Reality::DataSources::Wikidata::Impl::Actions::Post

      # A list of notification IDs to mark as read.
      #
      # @param values [Array<String>]
      # @return [self]
      def list(*values)
        values.inject(self) { |res, val| res._list(val) }
      end

      # @private
      def _list(value)
        merge(list: value.to_s, replace: false)
      end

      # A list of notification IDs to mark as unread.
      #
      # @param values [Array<String>]
      # @return [self]
      def unreadlist(*values)
        values.inject(self) { |res, val| res._unreadlist(val) }
      end

      # @private
      def _unreadlist(value)
        merge(unreadlist: value.to_s, replace: false)
      end

      # If set, marks all of a user's notifications as read.
      #
      # @return [self]
      def all()
        merge(all: 'true')
      end

      # A list of sections to mark as read.
      #
      # @param values [Array<String>] Allowed values: "alert", "message".
      # @return [self]
      def sections(*values)
        values.inject(self) { |res, val| res._sections(val) or fail ArgumentError, "Unknown value for sections: #{val}" }
      end

      # @private
      def _sections(value)
        defined?(super) && super || ["alert", "message"].include?(value.to_s) && merge(sections: value.to_s, replace: false)
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
