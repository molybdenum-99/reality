# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Find all pages that link to the given interwiki link.
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
    module Iwbacklinks

      # Prefix for the interwiki.
      #
      # @param value [String]
      # @return [self]
      def prefix(value)
        merge(iwblprefix: value.to_s)
      end

      # Interwiki link to search for. Must be used with iwblblprefix.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(iwbltitle: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(iwblcontinue: value.to_s)
      end

      # How many total pages to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(iwbllimit: value.to_s)
      end

      # Which properties to get:
      #
      # @param values [Array<String>] Allowed values: "iwprefix" (Adds the prefix of the interwiki), "iwtitle" (Adds the title of the interwiki).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["iwprefix", "iwtitle"].include?(value.to_s) && merge(iwblprop: value.to_s, replace: false)
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
        defined?(super) && super || ["ascending", "descending"].include?(value.to_s) && merge(iwbldir: value.to_s)
      end
    end
  end
end
