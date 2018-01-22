# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Request all map data from the page Metallica
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
    module Mapdata

      # Pipe-separated groups to return data for
      #
      # @param value [String]
      # @return [self]
      def groups(value)
        merge(mpdgroups: value.to_s)
      end

      # Data for how many pages to return
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(mpdlimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [Integer]
      # @return [self]
      def continue(value)
        merge(mpdcontinue: value.to_s)
      end
    end
  end
end
