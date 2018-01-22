# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Show details of the abuse filters.
    #
    # The "submodule" (MediaWiki API term) is included in action after setting some param, providing
    # additional tweaking for this param. Example (for {Reality::DataSources::Wikidata::Impl::Actions::Query} and
    # its submodules):
    #
    # ```ruby
    # api.query             # returns Actions::Query
    #    .prop(:revisions)  # adds prop=revisions to action URL, and includes Modules::Revisions into action
    #    .limit(10)         # method of Modules::Revisions, adds rvlimit=10 to URL
    # ```
    #
    # All submodule's parameters are documented as its public methods, see below.
    #
    module Abusefilters

      # The filter ID to start enumerating from.
      #
      # @param value [Integer]
      # @return [self]
      def startid(value)
        merge(abfstartid: value.to_s)
      end

      # The filter ID to stop enumerating at.
      #
      # @param value [Integer]
      # @return [self]
      def endid(value)
        merge(abfendid: value.to_s)
      end

      # In which direction to enumerate:
      #
      # @param value [String] One of "newer" (List oldest first. Note: abfstart has to be before abfend), "older" (List newest first (default). Note: abfstart has to be later than abfend).
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["newer", "older"].include?(value.to_s) && merge(abfdir: value.to_s)
      end

      # Show only filters which meet these criteria.
      #
      # @param values [Array<String>] Allowed values: "enabled", "!enabled", "deleted", "!deleted", "private", "!private".
      # @return [self]
      def show(*values)
        values.inject(self) { |res, val| res._show(val) or fail ArgumentError, "Unknown value for show: #{val}" }
      end

      # @private
      def _show(value)
        defined?(super) && super || ["enabled", "!enabled", "deleted", "!deleted", "private", "!private"].include?(value.to_s) && merge(abfshow: value.to_s, replace: false)
      end

      # The maximum number of filters to list.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(abflimit: value.to_s)
      end

      # Which properties to get.
      #
      # @param values [Array<String>] Allowed values: "id", "description", "pattern", "actions", "hits", "comments", "lasteditor", "lastedittime", "status", "private".
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["id", "description", "pattern", "actions", "hits", "comments", "lasteditor", "lastedittime", "status", "private"].include?(value.to_s) && merge(abfprop: value.to_s, replace: false)
      end
    end
  end
end
