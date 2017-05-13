# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Search the wiki using the OpenSearch protocol.
    #
    # Usage:
    #
    # ```ruby
    # api.opensearch.search(value).perform # returns string with raw output
    # # or
    # api.opensearch.search(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Opensearch < Reality::DataSources::Wikidata::Impl::Actions::Get

      # Search string.
      #
      # @param value [String]
      # @return [self]
      def search(value)
        merge(search: value.to_s)
      end

      # Namespaces to search.
      #
      # @param values [Array<String>] Allowed values: "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600".
      # @return [self]
      def namespace(*values)
        values.inject(self) { |res, val| res._namespace(val) or fail ArgumentError, "Unknown value for namespace: #{val}" }
      end

      # @private
      def _namespace(value)
        defined?(super) && super || ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600"].include?(value.to_s) && merge(namespace: value.to_s, replace: false)
      end

      # Maximum number of results to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(limit: value.to_s)
      end

      # Do nothing if $wgEnableOpenSearchSuggest is false.
      #
      # @return [self]
      def suggest()
        merge(suggest: 'true')
      end

      # How to handle redirects:
      #
      # @param value [String] One of "return" (Return the redirect itself), "resolve" (Return the target page. May return fewer than limit results).
      # @return [self]
      def redirects(value)
        _redirects(value) or fail ArgumentError, "Unknown value for redirects: #{value}"
      end

      # @private
      def _redirects(value)
        defined?(super) && super || ["return", "resolve"].include?(value.to_s) && merge(redirects: value.to_s)
      end

      # The format of the output.
      #
      # @param value [String] One of "json", "jsonfm", "xml", "xmlfm".
      # @return [self]
      def format(value)
        _format(value) or fail ArgumentError, "Unknown value for format: #{value}"
      end

      # @private
      def _format(value)
        defined?(super) && super || ["json", "jsonfm", "xml", "xmlfm"].include?(value.to_s) && merge(format: value.to_s)
      end

      # If warnings are raised with format=json, return an API error instead of ignoring them.
      #
      # @return [self]
      def warningsaserror()
        merge(warningsaserror: 'true')
      end
    end
  end
end
