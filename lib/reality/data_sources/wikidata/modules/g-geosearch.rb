# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Returns pages having coordinates that are located in a certain area. _Generator module: for fetching pages corresponding to request._
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
    module GGeosearch

      # Coordinate around which to search.
      #
      # @param value [String]
      # @return [self]
      def coord(value)
        merge(ggscoord: value.to_s)
      end

      # Title of page around which to search.
      #
      # @param value [String]
      # @return [self]
      def page(value)
        merge(ggspage: value.to_s)
      end

      # Bounding box to search in: pipe (|) separated coordinates of top left and bottom right corners.
      #
      # @param value [String]
      # @return [self]
      def bbox(value)
        merge(ggsbbox: value.to_s)
      end

      # Search radius in meters.
      #
      # @param value [Integer]
      # @return [self]
      def radius(value)
        merge(ggsradius: value.to_s)
      end

      # Restrict search to objects no larger than this, in meters.
      #
      # @param value [Integer]
      # @return [self]
      def maxdim(value)
        merge(ggsmaxdim: value.to_s)
      end

      # Maximum number of pages to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(ggslimit: value.to_s)
      end

      # Globe to search on (by default "earth").
      #
      # @param value [String] One of "earth".
      # @return [self]
      def globe(value)
        _globe(value) or fail ArgumentError, "Unknown value for globe: #{value}"
      end

      # @private
      def _globe(value)
        defined?(super) && super || ["earth"].include?(value.to_s) && merge(ggsglobe: value.to_s)
      end

      # Namespaces to search.
      #
      # @param values [Array<String>] Allowed values: "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600".
      # @return [self]
      def namespace(*values)
        values.inject(self) { |res, val| res._namespace(val) or fail ArgumentError, "Unknown value for namespace: #{val}" }
      end

      # @private
      def _namespace(value)
        defined?(super) && super || ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600"].include?(value.to_s) && merge(ggsnamespace: value.to_s, replace: false)
      end

      # Whether to return only primary coordinates ("primary"), secondary ("secondary") or both ("all").
      #
      # @param value [String] One of "primary", "secondary", "all".
      # @return [self]
      def primary(value)
        _primary(value) or fail ArgumentError, "Unknown value for primary: #{value}"
      end

      # @private
      def _primary(value)
        defined?(super) && super || ["primary", "secondary", "all"].include?(value.to_s) && merge(ggsprimary: value.to_s)
      end

      # Whether debug information should be returned.
      #
      # @return [self]
      def debug()
        merge(ggsdebug: 'true')
      end
    end
  end
end
