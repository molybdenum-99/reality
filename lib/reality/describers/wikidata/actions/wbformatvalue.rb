# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Formats DataValues.
    #
    # Usage:
    #
    # ```ruby
    # api.wbformatvalue.generate(value).perform # returns string with raw output
    # # or
    # api.wbformatvalue.generate(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Wbformatvalue < Reality::Describers::Wikidata::Impl::Actions::Get

      # The desired output format to generate.
      #
      # @param value [String] One of "text/plain", "text/x-wiki", "text/html", "text/html; disposition=widget".
      # @return [self]
      def generate(value)
        _generate(value) or fail ArgumentError, "Unknown value for generate: #{value}"
      end

      # @private
      def _generate(value)
        defined?(super) && super || ["text/plain", "text/x-wiki", "text/html", "text/html; disposition=widget"].include?(value.to_s) && merge(generate: value.to_s)
      end

      # The data to format. This has to be the JSON serialization of a DataValue object.
      #
      # @param value [String]
      # @return [self]
      def datavalue(value)
        merge(datavalue: value.to_s)
      end

      # The value's data type. This is distinct from the value's type
      #
      # @param value [String] One of "commonsMedia", "geo-shape", "globe-coordinate", "monolingualtext", "quantity", "string", "time", "url", "external-id", "wikibase-item", "wikibase-property", "math".
      # @return [self]
      def datatype(value)
        _datatype(value) or fail ArgumentError, "Unknown value for datatype: #{value}"
      end

      # @private
      def _datatype(value)
        defined?(super) && super || ["commonsMedia", "geo-shape", "globe-coordinate", "monolingualtext", "quantity", "string", "time", "url", "external-id", "wikibase-item", "wikibase-property", "math"].include?(value.to_s) && merge(datatype: value.to_s)
      end

      # Property ID the data value belongs to, should be used instead of the datatype parameter.
      #
      # @param value [String]
      # @return [self]
      def property(value)
        merge(property: value.to_s)
      end

      # The options the formatter should use. Provided as a JSON object.
      #
      # @param value [String]
      # @return [self]
      def options(value)
        merge(options: value.to_s)
      end
    end
  end
end
