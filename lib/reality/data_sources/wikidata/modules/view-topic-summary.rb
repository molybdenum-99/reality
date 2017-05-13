# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # View a topic summary.
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
    module ViewTopicSummary

      # Format to return the content in.
      #
      # @param value [String] One of "html", "wikitext", "fixed-html".
      # @return [self]
      def format(value)
        _format(value) or fail ArgumentError, "Unknown value for format: #{value}"
      end

      # @private
      def _format(value)
        defined?(super) && super || ["html", "wikitext", "fixed-html"].include?(value.to_s) && merge(vtsformat: value.to_s)
      end

      # Load this revision, instead of the most recent.
      #
      # @param value [String]
      # @return [self]
      def revId(value)
        merge(vtsrevId: value.to_s)
      end
    end
  end
end
