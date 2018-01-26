# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Get various page properties defined in the page content.
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
    module Pageprops

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(ppcontinue: value.to_s)
      end

      # Only list these page properties (action=query&list=pagepropnames returns page property names in use). Useful for checking whether pages use a certain page property.
      #
      # @param values [Array<String>]
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) }
      end

      # @private
      def _prop(value)
        merge(ppprop: value.to_s, replace: false)
      end
    end
  end
end
