# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Find all pages that link to the given interwiki link. _Generator module: for fetching pages corresponding to request._
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
    module GIwbacklinks

      # Prefix for the interwiki.
      #
      # @param value [String]
      # @return [self]
      def prefix(value)
        merge(giwblprefix: value.to_s)
      end

      # Interwiki link to search for. Must be used with iwblblprefix.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(giwbltitle: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(giwblcontinue: value.to_s)
      end

      # How many total pages to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(giwbllimit: value.to_s)
      end

      # The direction in which to list.
      #
      # @param value [String] One of "ascending", "descending".
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["ascending", "descending"].include?(value.to_s) && merge(giwbldir: value.to_s)
      end
    end
  end
end
