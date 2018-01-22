# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Undo the last edit to the page.
    #
    # Usage:
    #
    # ```ruby
    # api.rollback.title(value).perform # returns string with raw output
    # # or
    # api.rollback.title(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Rollback < Reality::DataSources::Wikidata::Impl::Actions::Post

      # Title of the page to roll back. Cannot be used together with pageid.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(title: value.to_s)
      end

      # Page ID of the page to roll back. Cannot be used together with title.
      #
      # @param value [Integer]
      # @return [self]
      def pageid(value)
        merge(pageid: value.to_s)
      end

      # Tags to apply to the rollback.
      #
      # @param values [Array<String>] Allowed values: "InfoboxExport gadget", "WE-Framework gadget".
      # @return [self]
      def tags(*values)
        values.inject(self) { |res, val| res._tags(val) or fail ArgumentError, "Unknown value for tags: #{val}" }
      end

      # @private
      def _tags(value)
        defined?(super) && super || ["InfoboxExport gadget", "WE-Framework gadget"].include?(value.to_s) && merge(tags: value.to_s, replace: false)
      end

      # Name of the user whose edits are to be rolled back.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(user: value.to_s)
      end

      # Custom edit summary. If empty, default summary will be used.
      #
      # @param value [String]
      # @return [self]
      def summary(value)
        merge(summary: value.to_s)
      end

      # Mark the reverted edits and the revert as bot edits.
      #
      # @return [self]
      def markbot()
        merge(markbot: 'true')
      end

      # Unconditionally add or remove the page from the current user's watchlist, use preferences or do not change watch.
      #
      # @param value [String] One of "watch", "unwatch", "preferences", "nochange".
      # @return [self]
      def watchlist(value)
        _watchlist(value) or fail ArgumentError, "Unknown value for watchlist: #{value}"
      end

      # @private
      def _watchlist(value)
        defined?(super) && super || ["watch", "unwatch", "preferences", "nochange"].include?(value.to_s) && merge(watchlist: value.to_s)
      end

      # A "rollback" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end
    end
  end
end
