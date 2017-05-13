# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Serve autocomplete requests for the site field in MassMessage.
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
    module Mmsites

      # The prefix to search for.
      #
      # @param value [String]
      # @return [self]
      def term(value)
        merge(term: value.to_s)
      end
    end
  end
end
