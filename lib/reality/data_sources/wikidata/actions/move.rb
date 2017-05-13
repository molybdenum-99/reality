# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Move a page.
    #
    # Usage:
    #
    # ```ruby
    # api.move.from(value).perform # returns string with raw output
    # # or
    # api.move.from(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Move < Reality::DataSources::Wikidata::Impl::Actions::Post

      # Title of the page to rename. Cannot be used together with fromid.
      #
      # @param value [String]
      # @return [self]
      def from(value)
        merge(from: value.to_s)
      end

      # Page ID of the page to rename. Cannot be used together with from.
      #
      # @param value [Integer]
      # @return [self]
      def fromid(value)
        merge(fromid: value.to_s)
      end

      # Title to rename the page to.
      #
      # @param value [String]
      # @return [self]
      def to(value)
        merge(to: value.to_s)
      end

      # Reason for the rename.
      #
      # @param value [String]
      # @return [self]
      def reason(value)
        merge(reason: value.to_s)
      end

      # Rename the talk page, if it exists.
      #
      # @return [self]
      def movetalk()
        merge(movetalk: 'true')
      end

      # Rename subpages, if applicable.
      #
      # @return [self]
      def movesubpages()
        merge(movesubpages: 'true')
      end

      # Don't create a redirect.
      #
      # @return [self]
      def noredirect()
        merge(noredirect: 'true')
      end

      # Add the page and the redirect to the current user's watchlist.
      #
      # @return [self]
      def watch()
        merge(watch: 'true')
      end

      # Remove the page and the redirect from the current user's watchlist.
      #
      # @return [self]
      def unwatch()
        merge(unwatch: 'true')
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

      # Ignore any warnings.
      #
      # @return [self]
      def ignorewarnings()
        merge(ignorewarnings: 'true')
      end

      # Change tags to apply to the entry in the move log and to the null revision on the destination page.
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
