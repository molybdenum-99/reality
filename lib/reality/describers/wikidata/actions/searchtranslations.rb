# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Search translations.
    #
    # Usage:
    #
    # ```ruby
    # api.searchtranslations.service(value).perform # returns string with raw output
    # # or
    # api.searchtranslations.service(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Searchtranslations < Reality::Describers::Wikidata::Impl::Actions::Get

      # Which of the available translation services to use.
      #
      # @param value [String] One of "eqiad", "codfw".
      # @return [self]
      def service(value)
        _service(value) or fail ArgumentError, "Unknown value for service: #{value}"
      end

      # @private
      def _service(value)
        defined?(super) && super || ["eqiad", "codfw"].include?(value.to_s) && merge(service: value.to_s)
      end

      # The string to search for.
      #
      # @param value [String]
      # @return [self]
      def query(value)
        merge(query: value.to_s)
      end

      # The language code of the source text.
      #
      # @param value [String]
      # @return [self]
      def sourcelanguage(value)
        merge(sourcelanguage: value.to_s)
      end

      # The language code to search string for.
      #
      # @param value [String]
      # @return [self]
      def language(value)
        merge(language: value.to_s)
      end

      # The group ID to search string in.
      #
      # @param value [String]
      # @return [self]
      def group(value)
        merge(group: value.to_s)
      end

      # Message translation status filter.
      #
      # @param value [String] One of "translated", "fuzzy", "untranslated".
      # @return [self]
      def filter(value)
        _filter(value) or fail ArgumentError, "Unknown value for filter: #{value}"
      end

      # @private
      def _filter(value)
        defined?(super) && super || ["translated", "fuzzy", "untranslated"].include?(value.to_s) && merge(filter: value.to_s)
      end

      # Match any/all search words.
      #
      # @param value [String]
      # @return [self]
      def match(value)
        merge(match: value.to_s)
      end

      # Case (in)sensitive search.
      #
      # @param value [String]
      # @return [self]
      def case(value)
        merge(case: value.to_s)
      end

      # Offset for the translations.
      #
      # @param value [Integer]
      # @return [self]
      def offset(value)
        merge(offset: value.to_s)
      end

      # Size of the result.
      #
      # @param value [Integer]
      # @return [self]
      def limit(value)
        merge(limit: value.to_s)
      end
    end
  end
end
