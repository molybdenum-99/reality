# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # List all page property names in use on the wiki.
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
    module Pagepropnames

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(ppncontinue: value.to_s)
      end

      # The maximum number of names to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(ppnlimit: value.to_s)
      end
    end
  end
end
