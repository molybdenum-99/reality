# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Perform a full text search. _Generator module: for fetching pages corresponding to request._
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
    module GSearch

      # Search for page titles or content matching this value. You can use the search string to invoke special search features, depending on what the wiki's search backend implements.
      #
      # @param value [String]
      # @return [self]
      def search(value)
        merge(gsrsearch: value.to_s)
      end

      # Search only within these namespaces.
      #
      # @param values [Array<String>] Allowed values: "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600".
      # @return [self]
      def namespace(*values)
        values.inject(self) { |res, val| res._namespace(val) or fail ArgumentError, "Unknown value for namespace: #{val}" }
      end

      # @private
      def _namespace(value)
        defined?(super) && super || ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600"].include?(value.to_s) && merge(gsrnamespace: value.to_s, replace: false)
      end

      # How many total pages to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(gsrlimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [Integer]
      # @return [self]
      def offset(value)
        merge(gsroffset: value.to_s)
      end

      # Query independent profile to use (affects ranking algorithm).
      #
      # @param value [String] One of "classic" (Ranking based on the number of incoming links, some templates, article language and recency (templates/language/recency may not be activated on this wiki)), "classic_noboostlinks" (Ranking based on some templates, article language and recency when activated on this wiki), "empty" (Ranking based solely on query dependent features (for debug only)), "wsum_inclinks" (Weighted sum based on incoming links), "wsum_inclinks_pv" (Weighted sum based on incoming links and weekly pageviews), "popular_inclinks_pv" (Ranking based primarily on page views), "popular_inclinks" (Ranking based primarily on incoming link counts).
      # @return [self]
      def qiprofile(value)
        _qiprofile(value) or fail ArgumentError, "Unknown value for qiprofile: #{value}"
      end

      # @private
      def _qiprofile(value)
        defined?(super) && super || ["classic", "classic_noboostlinks", "empty", "wsum_inclinks", "wsum_inclinks_pv", "popular_inclinks_pv", "popular_inclinks"].include?(value.to_s) && merge(gsrqiprofile: value.to_s)
      end

      # Which type of search to perform.
      #
      # @param value [String] One of "title", "text", "nearmatch".
      # @return [self]
      def what(value)
        _what(value) or fail ArgumentError, "Unknown value for what: #{value}"
      end

      # @private
      def _what(value)
        defined?(super) && super || ["title", "text", "nearmatch"].include?(value.to_s) && merge(gsrwhat: value.to_s)
      end

      # Which metadata to return.
      #
      # @param values [Array<String>] Allowed values: "totalhits", "suggestion", "rewrittenquery".
      # @return [self]
      def info(*values)
        values.inject(self) { |res, val| res._info(val) or fail ArgumentError, "Unknown value for info: #{val}" }
      end

      # @private
      def _info(value)
        defined?(super) && super || ["totalhits", "suggestion", "rewrittenquery"].include?(value.to_s) && merge(gsrinfo: value.to_s, replace: false)
      end

      # Include interwiki results in the search, if available.
      #
      # @return [self]
      def interwiki()
        merge(gsrinterwiki: 'true')
      end

      # Enable internal query rewriting. Some search backends can rewrite the query into one its thinks gives better results, such as correcting spelling errors.
      #
      # @return [self]
      def enablerewrites()
        merge(gsrenablerewrites: 'true')
      end
    end
  end
end
