# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Delete a page.
    #
    # Usage:
    #
    # ```ruby
    # api.delete.title(value).perform # returns string with raw output
    # # or
    # api.delete.title(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Delete < Reality::Describers::Wikidata::Impl::Actions::Post

      # Title of the page to delete. Cannot be used together with pageid.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(title: value.to_s)
      end

      # Page ID of the page to delete. Cannot be used together with title.
      #
      # @param value [Integer]
      # @return [self]
      def pageid(value)
        merge(pageid: value.to_s)
      end

      # Reason for the deletion. If not set, an automatically generated reason will be used.
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

      # Add the page to the current user's watchlist.
      #
      # @return [self]
      def watch()
        merge(watch: 'true')
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

      # Remove the page from the current user's watchlist.
      #
      # @return [self]
      def unwatch()
        merge(unwatch: 'true')
      end

      # The name of the old image to delete as provided by action=query&prop=imageinfo&iiprop=archivename.
      #
      # @param value [String]
      # @return [self]
      def oldimage(value)
        merge(oldimage: value.to_s)
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
