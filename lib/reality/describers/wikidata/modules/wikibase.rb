# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Get information about the Wikibase client and the associated Wikibase repository.
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
    module Wikibase

      # Which properties to get:
      #
      # @param values [Array<String>] Allowed values: "url" ( Base URL, script path and article path of the Wikibase repository), "siteid" ( The siteid of this site).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["url", "siteid"].include?(value.to_s) && merge(wbprop: value.to_s, replace: false)
      end
    end
  end
end
