# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Edits a topic's title.
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
    module EditTitle

      # Revision ID of the current title revision, to check for edit conflicts.
      #
      # @param value [String]
      # @return [self]
      def prev_revision(value)
        merge(etprev_revision: value.to_s)
      end

      # Content for title, in the same format allowed for edit summaries (topic-title-wikitext).
      #
      # @param value [String]
      # @return [self]
      def content(value)
        merge(etcontent: value.to_s)
      end

      # A "csrf" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end
    end
  end
end
