# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Enumerate all links that point to a given namespace.
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
    module Alllinks

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(alcontinue: value.to_s)
      end

      # The title of the link to start enumerating from.
      #
      # @param value [String]
      # @return [self]
      def from(value)
        merge(alfrom: value.to_s)
      end

      # The title of the link to stop enumerating at.
      #
      # @param value [String]
      # @return [self]
      def to(value)
        merge(alto: value.to_s)
      end

      # Search for all linked titles that begin with this value.
      #
      # @param value [String]
      # @return [self]
      def prefix(value)
        merge(alprefix: value.to_s)
      end

      # Only show distinct linked titles. Cannot be used with alprop=ids. When used as a generator, yields target pages instead of source pages.
      #
      # @return [self]
      def unique()
        merge(alunique: 'true')
      end

      # Which pieces of information to include:
      #
      # @param values [Array<String>] Allowed values: "ids" (Adds the page ID of the linking page (cannot be used with alunique)), "title" (Adds the title of the link).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["ids", "title"].include?(value.to_s) && merge(alprop: value.to_s, replace: false)
      end

      # The namespace to enumerate.
      #
      # @param value [String] One of "-2", "-1", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600".
      # @return [self]
      def namespace(value)
        _namespace(value) or fail ArgumentError, "Unknown value for namespace: #{value}"
      end

      # @private
      def _namespace(value)
        defined?(super) && super || ["-2", "-1", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600"].include?(value.to_s) && merge(alnamespace: value.to_s)
      end

      # How many total items to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(allimit: value.to_s)
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
        defined?(super) && super || ["ascending", "descending"].include?(value.to_s) && merge(aldir: value.to_s)
      end
    end
  end
end
