# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Show events that were caught by one of the abuse filters.
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
    module Abuselog

      # The timestamp to start enumerating from.
      #
      # @param value [Time]
      # @return [self]
      def start(value)
        merge(aflstart: value.iso8601)
      end

      # The timestamp to stop enumerating at.
      #
      # @param value [Time]
      # @return [self]
      def end(value)
        merge(aflend: value.iso8601)
      end

      # In which direction to enumerate:
      #
      # @param value [String] One of "newer" (List oldest first. Note: aflstart has to be before aflend), "older" (List newest first (default). Note: aflstart has to be later than aflend).
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["newer", "older"].include?(value.to_s) && merge(afldir: value.to_s)
      end

      # Show only entries done by a given user or IP address.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(afluser: value.to_s)
      end

      # Show only entries occurring on a given page.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(afltitle: value.to_s)
      end

      # Show only entries that were caught by a given filter ID.
      #
      # @param values [Array<String>]
      # @return [self]
      def filter(*values)
        values.inject(self) { |res, val| res._filter(val) }
      end

      # @private
      def _filter(value)
        merge(aflfilter: value.to_s, replace: false)
      end

      # The maximum amount of entries to list.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(afllimit: value.to_s)
      end

      # Which properties to get.
      #
      # @param values [Array<String>] Allowed values: "ids", "filter", "user", "ip", "title", "action", "details", "result", "timestamp", "hidden", "revid".
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["ids", "filter", "user", "ip", "title", "action", "details", "result", "timestamp", "hidden", "revid"].include?(value.to_s) && merge(aflprop: value.to_s, replace: false)
      end
    end
  end
end
