# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Edits a post's content.
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
    module EditPost

      # Post ID.
      #
      # @param value [String]
      # @return [self]
      def postId(value)
        merge(eppostId: value.to_s)
      end

      # Revision ID of the current post revision, to check for edit conflicts.
      #
      # @param value [String]
      # @return [self]
      def prev_revision(value)
        merge(epprev_revision: value.to_s)
      end

      # Content for post.
      #
      # @param value [String]
      # @return [self]
      def content(value)
        merge(epcontent: value.to_s)
      end

      # Format of the post content (wikitext|html)
      #
      # @param value [String] One of "html", "wikitext".
      # @return [self]
      def format(value)
        _format(value) or fail ArgumentError, "Unknown value for format: #{value}"
      end

      # @private
      def _format(value)
        defined?(super) && super || ["html", "wikitext"].include?(value.to_s) && merge(epformat: value.to_s)
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
