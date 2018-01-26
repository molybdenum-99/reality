# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # List all files that are duplicates of the given files based on hash values. _Generator module: for fetching pages corresponding to request._
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
    module GDuplicatefiles

      # How many duplicate files to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(gdflimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(gdfcontinue: value.to_s)
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
        defined?(super) && super || ["ascending", "descending"].include?(value.to_s) && merge(gdfdir: value.to_s)
      end

      # Look only for files in the local repository.
      #
      # @return [self]
      def localonly()
        merge(gdflocalonly: 'true')
      end
    end
  end
end
