# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Get subscriptions to given entities.
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
    module Wbsubscribers

      # Entities to get subscribers
      #
      # @param values [Array<String>]
      # @return [self]
      def entities(*values)
        values.inject(self) { |res, val| res._entities(val) }
      end

      # @private
      def _entities(value)
        merge(wblsentities: value.to_s, replace: false)
      end

      # Properties to add to result
      #
      # @param values [Array<String>] Allowed values: "url".
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["url"].include?(value.to_s) && merge(wblsprop: value.to_s, replace: false)
      end

      # Maximal number of results
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(wblslimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(wblscontinue: value.to_s)
      end
    end
  end
end
