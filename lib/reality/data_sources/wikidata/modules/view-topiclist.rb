# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # View a list of topics.
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
    module ViewTopiclist

      # Direction to order the topics.
      #
      # @param value [String] One of "fwd", "rev".
      # @return [self]
      def offset_dir(value)
        _offset_dir(value) or fail ArgumentError, "Unknown value for offset_dir: #{value}"
      end

      # @private
      def _offset_dir(value)
        defined?(super) && super || ["fwd", "rev"].include?(value.to_s) && merge('vtloffset-dir': value.to_s)
      end

      # Sorting option of the topics, either updated (ordered by topic update time), or newest (ordered by topic creation time).
      #
      # @param value [String] One of "newest", "updated", "user".
      # @return [self]
      def sortby(value)
        _sortby(value) or fail ArgumentError, "Unknown value for sortby: #{value}"
      end

      # @private
      def _sortby(value)
        defined?(super) && super || ["newest", "updated", "user"].include?(value.to_s) && merge(vtlsortby: value.to_s)
      end

      # Save sortby option to user preferences, if set.
      #
      # @return [self]
      def savesortby()
        merge(vtlsavesortby: 'true')
      end

      # Offset value (in UUID format) to start fetching topics at; used only with newest ordering
      #
      # @param value [String]
      # @return [self]
      def offset_id(value)
        merge('vtloffset-id': value.to_s)
      end

      # Offset value (as a topic update timestamp, in TS_MW format (YYYYMMDDHHMMSS)), to start fetching topics at; used only with updated ordering
      #
      # @param value [String]
      # @return [self]
      def offset(value)
        merge(vtloffset: value.to_s)
      end

      # Includes the offset item in the results as well.
      #
      # @return [self]
      def include_offset()
        merge('vtlinclude-offset': 'true')
      end

      # Number of topics to fetch.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(vtllimit: value.to_s)
      end

      # Whether to respond with only the information required for the TOC.
      #
      # @return [self]
      def toconly()
        merge(vtltoconly: 'true')
      end

      # Format to return the content in.
      #
      # @param value [String] One of "html", "wikitext", "fixed-html".
      # @return [self]
      def format(value)
        _format(value) or fail ArgumentError, "Unknown value for format: #{value}"
      end

      # @private
      def _format(value)
        defined?(super) && super || ["html", "wikitext", "fixed-html"].include?(value.to_s) && merge(vtlformat: value.to_s)
      end
    end
  end
end
