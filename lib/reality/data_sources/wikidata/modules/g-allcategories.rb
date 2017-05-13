# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Enumerate all categories. _Generator module: for fetching pages corresponding to request._
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
    module GAllcategories

      # The category to start enumerating from.
      #
      # @param value [String]
      # @return [self]
      def from(value)
        merge(gacfrom: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(gaccontinue: value.to_s)
      end

      # The category to stop enumerating at.
      #
      # @param value [String]
      # @return [self]
      def to(value)
        merge(gacto: value.to_s)
      end

      # Search for all category titles that begin with this value.
      #
      # @param value [String]
      # @return [self]
      def prefix(value)
        merge(gacprefix: value.to_s)
      end

      # Direction to sort in.
      #
      # @param value [String] One of "ascending", "descending".
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["ascending", "descending"].include?(value.to_s) && merge(gacdir: value.to_s)
      end

      # Only return categories with at least this many members.
      #
      # @param value [Integer]
      # @return [self]
      def min(value)
        merge(gacmin: value.to_s)
      end

      # Only return categories with at most this many members.
      #
      # @param value [Integer]
      # @return [self]
      def max(value)
        merge(gacmax: value.to_s)
      end

      # How many categories to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(gaclimit: value.to_s)
      end
    end
  end
end
