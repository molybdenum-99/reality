# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Edits a topic summary's content.
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
    module EditTopicSummary

      # Revision ID of the current topic summary revision, if any, to check for edit conflicts.
      #
      # @param value [String]
      # @return [self]
      def prev_revision(value)
        merge(etsprev_revision: value.to_s)
      end

      # Content for the summary.
      #
      # @param value [String]
      # @return [self]
      def summary(value)
        merge(etssummary: value.to_s)
      end

      # Format of the summary (wikitext|html)
      #
      # @param value [String] One of "html", "wikitext".
      # @return [self]
      def format(value)
        _format(value) or fail ArgumentError, "Unknown value for format: #{value}"
      end

      # @private
      def _format(value)
        defined?(super) && super || ["html", "wikitext"].include?(value.to_s) && merge(etsformat: value.to_s)
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
