# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Get a set of random pages. _Generator module: for fetching pages corresponding to request._
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
    module GRandom

      # Return pages in these namespaces only.
      #
      # @param values [Array<String>] Allowed values: "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600".
      # @return [self]
      def namespace(*values)
        values.inject(self) { |res, val| res._namespace(val) or fail ArgumentError, "Unknown value for namespace: #{val}" }
      end

      # @private
      def _namespace(value)
        defined?(super) && super || ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600"].include?(value.to_s) && merge(grnnamespace: value.to_s, replace: false)
      end

      # How to filter for redirects.
      #
      # @param value [String] One of "all", "redirects", "nonredirects".
      # @return [self]
      def filterredir(value)
        _filterredir(value) or fail ArgumentError, "Unknown value for filterredir: #{value}"
      end

      # @private
      def _filterredir(value)
        defined?(super) && super || ["all", "redirects", "nonredirects"].include?(value.to_s) && merge(grnfilterredir: value.to_s)
      end

      # Use rnfilterredir=redirects instead.
      #
      # @return [self]
      def redirect()
        merge(grnredirect: 'true')
      end

      # Limit how many random pages will be returned.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(grnlimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(grncontinue: value.to_s)
      end
    end
  end
end
