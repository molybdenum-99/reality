# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Find all pages that link to the given language link.
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
    module Langbacklinks

      # Language for the language link.
      #
      # @param value [String]
      # @return [self]
      def lang(value)
        merge(lbllang: value.to_s)
      end

      # Language link to search for. Must be used with lbllang.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(lbltitle: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(lblcontinue: value.to_s)
      end

      # How many total pages to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(lbllimit: value.to_s)
      end

      # Which properties to get:
      #
      # @param values [Array<String>] Allowed values: "lllang" (Adds the language code of the language link), "lltitle" (Adds the title of the language link).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["lllang", "lltitle"].include?(value.to_s) && merge(lblprop: value.to_s, replace: false)
      end

      # The direction in which to list.
      #
      # @param value [String] One of "ascending", "descending".
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["ascending", "descending"].include?(value.to_s) && merge(lbldir: value.to_s)
      end
    end
  end
end
