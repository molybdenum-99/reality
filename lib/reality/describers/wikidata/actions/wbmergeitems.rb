# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Merges multiple items.
    #
    # Usage:
    #
    # ```ruby
    # api.wbmergeitems.fromid(value).perform # returns string with raw output
    # # or
    # api.wbmergeitems.fromid(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Wbmergeitems < Reality::DataSources::Wikidata::Impl::Actions::Post

      # The ID to merge from
      #
      # @param value [String]
      # @return [self]
      def fromid(value)
        merge(fromid: value.to_s)
      end

      # The ID to merge to
      #
      # @param value [String]
      # @return [self]
      def toid(value)
        merge(toid: value.to_s)
      end

      # Array of elements of the item to ignore conflicts for. Can only contain values of "description", "sitelink" and "statement"
      #
      # @param values [Array<String>] Allowed values: "description", "sitelink", "statement".
      # @return [self]
      def ignoreconflicts(*values)
        values.inject(self) { |res, val| res._ignoreconflicts(val) or fail ArgumentError, "Unknown value for ignoreconflicts: #{val}" }
      end

      # @private
      def _ignoreconflicts(value)
        defined?(super) && super || ["description", "sitelink", "statement"].include?(value.to_s) && merge(ignoreconflicts: value.to_s, replace: false)
      end

      # Summary for the edit. Will be prepended by an automatically generated comment. The length limit of the autocomment together with the summary is 260 characters. Be aware that everything above that limit will be cut off.
      #
      # @param value [String]
      # @return [self]
      def summary(value)
        merge(summary: value.to_s)
      end

      # Mark this edit as bot. This URL flag will only be respected if the user belongs to the group "bot".
      #
      # @return [self]
      def bot()
        merge(bot: 'true')
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
