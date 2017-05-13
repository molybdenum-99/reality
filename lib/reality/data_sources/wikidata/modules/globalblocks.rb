# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # List all globally blocked IP addresses.
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
    module Globalblocks

      # The timestamp to start enumerating from.
      #
      # @param value [Time]
      # @return [self]
      def start(value)
        merge(bgstart: value.iso8601)
      end

      # The timestamp to stop enumerating at.
      #
      # @param value [Time]
      # @return [self]
      def end(value)
        merge(bgend: value.iso8601)
      end

      # In which direction to enumerate:
      #
      # @param value [String] One of "newer" (List oldest first. Note: bgstart has to be before bgend), "older" (List newest first (default). Note: bgstart has to be later than bgend).
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["newer", "older"].include?(value.to_s) && merge(bgdir: value.to_s)
      end

      # Pipe-separated list of block IDs to list.
      #
      # @param values [Array<Integer>]
      # @return [self]
      def ids(*values)
        values.inject(self) { |res, val| res._ids(val) }
      end

      # @private
      def _ids(value)
        merge(bgids: value.to_s, replace: false)
      end

      # Pipe-separated list of IP addresses to search for.
      #
      # @param values [Array<String>]
      # @return [self]
      def addresses(*values)
        values.inject(self) { |res, val| res._addresses(val) }
      end

      # @private
      def _addresses(value)
        merge(bgaddresses: value.to_s, replace: false)
      end

      # Get all blocks applying to this IP address or CIDR range, including range blocks. Cannot be used together with bgaddresses. CIDR ranges broader than /16 are not accepted.
      #
      # @param value [String]
      # @return [self]
      def ip(value)
        merge(bgip: value.to_s)
      end

      # The maximum amount of blocks to list.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(bglimit: value.to_s)
      end

      # Which properties to get.
      #
      # @param values [Array<String>] Allowed values: "id", "address", "by", "timestamp", "expiry", "reason", "range".
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["id", "address", "by", "timestamp", "expiry", "reason", "range"].include?(value.to_s) && merge(bgprop: value.to_s, replace: false)
      end
    end
  end
end
