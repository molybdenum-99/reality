# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Returns coordinates of the given pages.
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
    module Coordinates

      # How many coordinates to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(colimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(cocontinue: value.to_s)
      end

      # Which additional coordinate properties to return.
      #
      # @param values [Array<String>] Allowed values: "type", "name", "dim", "country", "region", "globe".
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["type", "name", "dim", "country", "region", "globe"].include?(value.to_s) && merge(coprop: value.to_s, replace: false)
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
        defined?(super) && super || ["primary", "secondary", "all"].include?(value.to_s) && merge(coprimary: value.to_s)
      end

      # Return distance in meters from the geographical coordinates of every valid result from the given coordinates.
      #
      # @param value [String]
      # @return [self]
      def distancefrompoint(value)
        merge(codistancefrompoint: value.to_s)
      end

      # Return distance in meters from the geographical coordinates of every valid result from the coordinates of this page.
      #
      # @param value [String]
      # @return [self]
      def distancefrompage(value)
        merge(codistancefrompage: value.to_s)
      end
    end
  end
end
