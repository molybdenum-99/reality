# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # List all categories the pages belong to.
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
    module Categories

      # Which additional properties to get for each category:
      #
      # @param values [Array<String>] Allowed values: "sortkey" (Adds the sortkey (hexadecimal string) and sortkey prefix (human-readable part) for the category), "timestamp" (Adds timestamp of when the category was added), "hidden" (Tags categories that are hidden with __HIDDENCAT__).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["sortkey", "timestamp", "hidden"].include?(value.to_s) && merge(clprop: value.to_s, replace: false)
      end

      # Which kind of categories to show.
      #
      # @param values [Array<String>] Allowed values: "hidden", "!hidden".
      # @return [self]
      def show(*values)
        values.inject(self) { |res, val| res._show(val) or fail ArgumentError, "Unknown value for show: #{val}" }
      end

      # @private
      def _show(value)
        defined?(super) && super || ["hidden", "!hidden"].include?(value.to_s) && merge(clshow: value.to_s, replace: false)
      end

      # How many categories to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(cllimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(clcontinue: value.to_s)
      end

      # Only list these categories. Useful for checking whether a certain page is in a certain category.
      #
      # @param values [Array<String>]
      # @return [self]
      def categories(*values)
        values.inject(self) { |res, val| res._categories(val) }
      end

      # @private
      def _categories(value)
        merge(clcategories: value.to_s, replace: false)
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
        defined?(super) && super || ["ascending", "descending"].include?(value.to_s) && merge(cldir: value.to_s)
      end
    end
  end
end
