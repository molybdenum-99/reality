# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Returns all interlanguage links from the given pages.
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
    module Langlinks

      # Which additional properties to get for each interlanguage link:
      #
      # @param values [Array<String>] Allowed values: "url" (Adds the full URL), "langname" (Adds the localised language name (best effort). Use llinlanguagecode to control the language), "autonym" (Adds the native language name).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["url", "langname", "autonym"].include?(value.to_s) && merge(llprop: value.to_s, replace: false)
      end

      # Only return language links with this language code.
      #
      # @param value [String]
      # @return [self]
      def lang(value)
        merge(lllang: value.to_s)
      end

      # Link to search for. Must be used with lllang.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(lltitle: value.to_s)
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
        defined?(super) && super || ["ascending", "descending"].include?(value.to_s) && merge(lldir: value.to_s)
      end

      # Language code for localised language names.
      #
      # @param value [String]
      # @return [self]
      def inlanguagecode(value)
        merge(llinlanguagecode: value.to_s)
      end

      # How many langlinks to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(lllimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(llcontinue: value.to_s)
      end

      # Whether to get the full URL (cannot be used with llprop).
      #
      # @return [self]
      def url()
        merge(llurl: 'true')
      end
    end
  end
end
