# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Parses values using a ValueParser.
    #
    # Usage:
    #
    # ```ruby
    # api.wbparsevalue.datatype(value).perform # returns string with raw output
    # # or
    # api.wbparsevalue.datatype(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Wbparsevalue < Reality::Describers::Wikidata::Impl::Actions::Get

      # Datatype of the value to parse. Determines the parser to use.
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

      # ID of the ValueParser to use. Deprecated. Use the datatype parameter instead.
      #
      # @param value [String] One of "wikibase-entityid", "globecoordinate", "null", "commonsMedia", "geo-shape", "globe-coordinate", "monolingualtext", "quantity", "string", "time", "url", "external-id", "wikibase-item", "wikibase-property", "math".
      # @return [self]
      def parser(value)
        _parser(value) or fail ArgumentError, "Unknown value for parser: #{value}"
      end

      # @private
      def _parser(value)
        defined?(super) && super || ["wikibase-entityid", "globecoordinate", "null", "commonsMedia", "geo-shape", "globe-coordinate", "monolingualtext", "quantity", "string", "time", "url", "external-id", "wikibase-item", "wikibase-property", "math"].include?(value.to_s) && merge(parser: value.to_s)
      end

      # The values to parse
      #
      # @param values [Array<String>]
      # @return [self]
      def values(*values)
        values.inject(self) { |res, val| res._values(val) }
      end

      # @private
      def _values(value)
        merge(values: value.to_s, replace: false)
      end

      # The options the parser should use. Provided as a JSON object.
      #
      # @param value [String]
      # @return [self]
      def options(value)
        merge(options: value.to_s)
      end

      # Whether to additionally verify the data passed in.
      #
      # @return [self]
      def validate()
        merge(validate: 'true')
      end
    end
  end
end
