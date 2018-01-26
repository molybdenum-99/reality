# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Returns a list of gadget categories.
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
    module Gadgetcategories

      # What gadget category information to get:
      #
      # @param values [Array<String>] Allowed values: "name" (Internal category name), "title" (Category title), "members" (Number of gadgets in category).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["name", "title", "members"].include?(value.to_s) && merge(gcprop: value.to_s, replace: false)
      end

      # Names of categories to retrieve.
      #
      # @param values [Array<String>]
      # @return [self]
      def names(*values)
        values.inject(self) { |res, val| res._names(val) }
      end

      # @private
      def _names(value)
        merge(gcnames: value.to_s, replace: false)
      end
    end
  end
end
