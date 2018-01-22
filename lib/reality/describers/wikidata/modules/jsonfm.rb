# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Output data in JSON format (pretty-print in HTML).
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
    module Jsonfm

      # Return the pretty-printed HTML and associated ResourceLoader modules as a JSON object.
      #
      # @return [self]
      def wrappedhtml()
        merge(wrappedhtml: 'true')
      end

      # If specified, wraps the output into a given function call. For safety, all user-specific data will be restricted.
      #
      # @param value [String]
      # @return [self]
      def callback(value)
        merge(callback: value.to_s)
      end

      # If specified, encodes most (but not all) non-ASCII characters as UTF-8 instead of replacing them with hexadecimal escape sequences. Default when formatversion is not 1.
      #
      # @return [self]
      def utf8()
        merge(utf8: 'true')
      end

      # If specified, encodes all non-ASCII using hexadecimal escape sequences. Default when formatversion is 1.
      #
      # @return [self]
      def ascii()
        merge(ascii: 'true')
      end

      # Output formatting:
      #
      # @param value [String] One of "1" (Backwards-compatible format (XML-style booleans, * keys for content nodes, etc.)), "2" (Experimental modern format. Details may change!), "latest" (Use the latest format (currently 2), may change without warning).
      # @return [self]
      def formatversion(value)
        _formatversion(value) or fail ArgumentError, "Unknown value for formatversion: #{value}"
      end

      # @private
      def _formatversion(value)
        defined?(super) && super || ["1", "2", "latest"].include?(value.to_s) && merge(formatversion: value.to_s)
      end
    end
  end
end
