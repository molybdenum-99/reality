# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Returns all interwiki links from the given pages.
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
    module Iwlinks

      # Which additional properties to get for each interlanguage link:
      #
      # @param values [Array<String>] Allowed values: "url" (Adds the full URL).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["url"].include?(value.to_s) && merge(iwprop: value.to_s, replace: false)
      end

      # Only return interwiki links with this prefix.
      #
      # @param value [String]
      # @return [self]
      def prefix(value)
        merge(iwprefix: value.to_s)
      end

      # Interwiki link to search for. Must be used with iwprefix.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(iwtitle: value.to_s)
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
        defined?(super) && super || ["ascending", "descending"].include?(value.to_s) && merge(iwdir: value.to_s)
      end

      # How many interwiki links to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(iwlimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(iwcontinue: value.to_s)
      end

      # Whether to get the full URL (cannot be used with iwprop).
      #
      # @return [self]
      def url()
        merge(iwurl: 'true')
      end
    end
  end
end
