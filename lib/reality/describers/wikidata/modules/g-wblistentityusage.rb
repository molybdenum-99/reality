# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Returns all pages that use the given entity IDs. _Generator module: for fetching pages corresponding to request._
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
    module GWblistentityusage

      # Only return entity IDs that used this aspect.
      #
      # @param values [Array<String>] Allowed values: "S", "L", "T", "X", "O".
      # @return [self]
      def aspect(*values)
        values.inject(self) { |res, val| res._aspect(val) or fail ArgumentError, "Unknown value for aspect: #{val}" }
      end

      # @private
      def _aspect(value)
        defined?(super) && super || ["S", "L", "T", "X", "O"].include?(value.to_s) && merge(gwbeuaspect: value.to_s, replace: false)
      end

      # Entities that have been used.
      #
      # @param values [Array<String>]
      # @return [self]
      def entities(*values)
        values.inject(self) { |res, val| res._entities(val) }
      end

      # @private
      def _entities(value)
        merge(gwbeuentities: value.to_s, replace: false)
      end

      # How many entity usages to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(gwbeulimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(gwbeucontinue: value.to_s)
      end
    end
  end
end
