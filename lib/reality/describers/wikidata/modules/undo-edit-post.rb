# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Retrieve information necesary to undo post edit.
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
    module UndoEditPost

      # Revision ID to start undo at.
      #
      # @param value [String]
      # @return [self]
      def startId(value)
        merge(uepstartId: value.to_s)
      end

      # Revision ID to end undo at.
      #
      # @param value [String]
      # @return [self]
      def endId(value)
        merge(uependId: value.to_s)
      end
    end
  end
end
