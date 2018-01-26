# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # List all pages using a given page property.
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
    module Pageswithprop

      # Page property for which to enumerate pages (action=query&list=pagepropnames returns page property names in use).
      #
      # @param value [String]
      # @return [self]
      def propname(value)
        merge(pwppropname: value.to_s)
      end

      # Which pieces of information to include:
      #
      # @param values [Array<String>] Allowed values: "ids" (Adds the page ID), "title" (Adds the title and namespace ID of the page), "value" (Adds the value of the page property).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["ids", "title", "value"].include?(value.to_s) && merge(pwpprop: value.to_s, replace: false)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(pwpcontinue: value.to_s)
      end

      # The maximum number of pages to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(pwplimit: value.to_s)
      end

      # In which direction to sort.
      #
      # @param value [String] One of "ascending", "descending".
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["ascending", "descending"].include?(value.to_s) && merge(pwpdir: value.to_s)
      end
    end
  end
end
