# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Query suggestions from translation memories.
    #
    # Usage:
    #
    # ```ruby
    # api.ttmserver.service(value).perform # returns string with raw output
    # # or
    # api.ttmserver.service(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Ttmserver < Reality::DataSources::Wikidata::Impl::Actions::Get

      # Which of the available translation services to use.
      #
      # @param value [String] One of "".
      # @return [self]
      def service(value)
        _service(value) or fail ArgumentError, "Unknown value for service: #{value}"
      end

      # @private
      def _service(value)
        defined?(super) && super || [""].include?(value.to_s) && merge(service: value.to_s)
      end

      # The language code of the source text.
      #
      # @param value [String]
      # @return [self]
      def sourcelanguage(value)
        merge(sourcelanguage: value.to_s)
      end

      # The language code of the suggestion.
      #
      # @param value [String]
      # @return [self]
      def targetlanguage(value)
        merge(targetlanguage: value.to_s)
      end

      # The text to find suggestions for.
      #
      # @param value [String]
      # @return [self]
      def text(value)
        merge(text: value.to_s)
      end
    end
  end
end
