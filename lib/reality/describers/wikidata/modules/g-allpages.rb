# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Enumerate all pages sequentially in a given namespace. _Generator module: for fetching pages corresponding to request._
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
    module GAllpages

      # The page title to start enumerating from.
      #
      # @param value [String]
      # @return [self]
      def from(value)
        merge(gapfrom: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(gapcontinue: value.to_s)
      end

      # The page title to stop enumerating at.
      #
      # @param value [String]
      # @return [self]
      def to(value)
        merge(gapto: value.to_s)
      end

      # Search for all page titles that begin with this value.
      #
      # @param value [String]
      # @return [self]
      def prefix(value)
        merge(gapprefix: value.to_s)
      end

      # The namespace to enumerate.
      #
      # @param value [String] One of "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600".
      # @return [self]
      def namespace(value)
        _namespace(value) or fail ArgumentError, "Unknown value for namespace: #{value}"
      end

      # @private
      def _namespace(value)
        defined?(super) && super || ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600"].include?(value.to_s) && merge(gapnamespace: value.to_s)
      end

      # Which pages to list.
      #
      # @param value [String] One of "all", "redirects", "nonredirects".
      # @return [self]
      def filterredir(value)
        _filterredir(value) or fail ArgumentError, "Unknown value for filterredir: #{value}"
      end

      # @private
      def _filterredir(value)
        defined?(super) && super || ["all", "redirects", "nonredirects"].include?(value.to_s) && merge(gapfilterredir: value.to_s)
      end

      # Limit to pages with at least this many bytes.
      #
      # @param value [Integer]
      # @return [self]
      def minsize(value)
        merge(gapminsize: value.to_s)
      end

      # Limit to pages with at most this many bytes.
      #
      # @param value [Integer]
      # @return [self]
      def maxsize(value)
        merge(gapmaxsize: value.to_s)
      end

      # Limit to protected pages only.
      #
      # @param values [Array<String>] Allowed values: "edit", "move", "upload".
      # @return [self]
      def prtype(*values)
        values.inject(self) { |res, val| res._prtype(val) or fail ArgumentError, "Unknown value for prtype: #{val}" }
      end

      # @private
      def _prtype(value)
        defined?(super) && super || ["edit", "move", "upload"].include?(value.to_s) && merge(gapprtype: value.to_s, replace: false)
      end

      # Filter protections based on protection level (must be used with apprtype= parameter).
      #
      # @param values [Array<String>] Allowed values: "autoconfirmed", "sysop".
      # @return [self]
      def prlevel(*values)
        values.inject(self) { |res, val| res._prlevel(val) or fail ArgumentError, "Unknown value for prlevel: #{val}" }
      end

      # @private
      def _prlevel(value)
        defined?(super) && super || ["autoconfirmed", "sysop"].include?(value.to_s) && merge(gapprlevel: value.to_s, replace: false)
      end

      # Filter protections based on cascadingness (ignored when apprtype isn't set).
      #
      # @param value [String] One of "cascading", "noncascading", "all".
      # @return [self]
      def prfiltercascade(value)
        _prfiltercascade(value) or fail ArgumentError, "Unknown value for prfiltercascade: #{value}"
      end

      # @private
      def _prfiltercascade(value)
        defined?(super) && super || ["cascading", "noncascading", "all"].include?(value.to_s) && merge(gapprfiltercascade: value.to_s)
      end

      # How many total pages to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(gaplimit: value.to_s)
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
        defined?(super) && super || ["ascending", "descending"].include?(value.to_s) && merge(gapdir: value.to_s)
      end

      # Filter based on whether a page has langlinks. Note that this may not consider langlinks added by extensions.
      #
      # @param value [String] One of "withlanglinks", "withoutlanglinks", "all".
      # @return [self]
      def filterlanglinks(value)
        _filterlanglinks(value) or fail ArgumentError, "Unknown value for filterlanglinks: #{value}"
      end

      # @private
      def _filterlanglinks(value)
        defined?(super) && super || ["withlanglinks", "withoutlanglinks", "all"].include?(value.to_s) && merge(gapfilterlanglinks: value.to_s)
      end

      # Which protection expiry to filter the page on:
      #
      # @param value [String] One of "indefinite" (Get only pages with indefinite protection expiry), "definite" (Get only pages with a definite (specific) protection expiry), "all" (Get pages with any protections expiry).
      # @return [self]
      def prexpiry(value)
        _prexpiry(value) or fail ArgumentError, "Unknown value for prexpiry: #{value}"
      end

      # @private
      def _prexpiry(value)
        defined?(super) && super || ["indefinite", "definite", "all"].include?(value.to_s) && merge(gapprexpiry: value.to_s)
      end
    end
  end
end
