# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Get the Wikidata terms (typically labels, descriptions and aliases) associated with a page via a sitelink. On the entity page itself, the terms are used directly. Caveat: On a repo wiki, this module only works directly on entity pages, not on pages connected to an entity via a sitelink. This may change in the future.
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
    module Pageterms

      # When more results are available, use this to continue.
      #
      # @param value [Integer]
      # @return [self]
      def continue(value)
        merge(wbptcontinue: value.to_s)
      end

      # The types of terms to get, e.g. 'description'. If not specified, all types are returned.
      #
      # @param values [Array<String>] Allowed values: "alias", "description", "label".
      # @return [self]
      def terms(*values)
        values.inject(self) { |res, val| res._terms(val) or fail ArgumentError, "Unknown value for terms: #{val}" }
      end

      # @private
      def _terms(value)
        defined?(super) && super || ["alias", "description", "label"].include?(value.to_s) && merge(wbptterms: value.to_s, replace: false)
      end
    end
  end
end
