# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # List all titles protected from creation. _Generator module: for fetching pages corresponding to request._
    #
    # The "submodule" (MediaWiki API term) is included in action after setting some param, providing
    # additional tweaking for this param. Example (for {Reality::Describers::Wikidata::Impl::Actions::Query} and
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
    module GProtectedtitles

      # Only list titles in these namespaces.
      #
      # @param values [Array<String>] Allowed values: "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600".
      # @return [self]
      def namespace(*values)
        values.inject(self) { |res, val| res._namespace(val) or fail ArgumentError, "Unknown value for namespace: #{val}" }
      end

      # @private
      def _namespace(value)
        defined?(super) && super || ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600"].include?(value.to_s) && merge(gptnamespace: value.to_s, replace: false)
      end

      # Only list titles with these protection levels.
      #
      # @param values [Array<String>] Allowed values: "autoconfirmed", "sysop".
      # @return [self]
      def level(*values)
        values.inject(self) { |res, val| res._level(val) or fail ArgumentError, "Unknown value for level: #{val}" }
      end

      # @private
      def _level(value)
        defined?(super) && super || ["autoconfirmed", "sysop"].include?(value.to_s) && merge(gptlevel: value.to_s, replace: false)
      end

      # How many total pages to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(gptlimit: value.to_s)
      end

      # In which direction to enumerate:
      #
      # @param value [String] One of "newer" (List oldest first. Note: ptstart has to be before ptend), "older" (List newest first (default). Note: ptstart has to be later than ptend).
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["newer", "older"].include?(value.to_s) && merge(gptdir: value.to_s)
      end

      # Start listing at this protection timestamp.
      #
      # @param value [Time]
      # @return [self]
      def start(value)
        merge(gptstart: value.iso8601)
      end

      # Stop listing at this protection timestamp.
      #
      # @param value [Time]
      # @return [self]
      def end(value)
        merge(gptend: value.iso8601)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(gptcontinue: value.to_s)
      end
    end
  end
end
