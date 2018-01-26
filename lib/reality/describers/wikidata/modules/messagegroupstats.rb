# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Query message group stats.
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
    module Messagegroupstats

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def offset(value)
        merge(mgsoffset: value.to_s)
      end

      # Maximum time to spend calculating missing statistics. If zero, only the cached results from the beginning are returned.
      #
      # @param value [Integer]
      # @return [self]
      def timelimit(value)
        merge(mgstimelimit: value.to_s)
      end

      # Message group ID.
      #
      # @param value [String]
      # @return [self]
      def group(value)
        merge(mgsgroup: value.to_s)
      end
    end
  end
end
