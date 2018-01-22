# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Restore revisions of a deleted page.
    #
    # Usage:
    #
    # ```ruby
    # api.undelete.title(value).perform # returns string with raw output
    # # or
    # api.undelete.title(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Undelete < Reality::DataSources::Wikidata::Impl::Actions::Post

      # Title of the page to restore.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(title: value.to_s)
      end

      # Reason for restoring.
      #
      # @param value [String]
      # @return [self]
      def reason(value)
        merge(reason: value.to_s)
      end

      # Change tags to apply to the entry in the deletion log.
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

      # Timestamps of the revisions to restore. If both timestamps and fileids are empty, all will be restored.
      #
      # @param values [Array<Time>]
      # @return [self]
      def timestamps(*values)
        values.inject(self) { |res, val| res._timestamps(val) }
      end

      # @private
      def _timestamps(value)
        merge(timestamps: value.iso8601, replace: false)
      end

      # IDs of the file revisions to restore. If both timestamps and fileids are empty, all will be restored.
      #
      # @param values [Array<Integer>]
      # @return [self]
      def fileids(*values)
        values.inject(self) { |res, val| res._fileids(val) }
      end

      # @private
      def _fileids(value)
        merge(fileids: value.to_s, replace: false)
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
