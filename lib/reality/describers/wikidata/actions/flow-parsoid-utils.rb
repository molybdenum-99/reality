# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Convert text between wikitext and HTML.
    #
    # Usage:
    #
    # ```ruby
    # api.flow-parsoid-utils.from(value).perform # returns string with raw output
    # # or
    # api.flow-parsoid-utils.from(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class FlowParsoidUtils < Reality::Describers::Wikidata::Impl::Actions::Get

      # Format to convert content from.
      #
      # @param value [String] One of "html", "wikitext".
      # @return [self]
      def from(value)
        _from(value) or fail ArgumentError, "Unknown value for from: #{value}"
      end

      # @private
      def _from(value)
        defined?(super) && super || ["html", "wikitext"].include?(value.to_s) && merge(from: value.to_s)
      end

      # Format to convert content to.
      #
      # @param value [String] One of "html", "wikitext".
      # @return [self]
      def to(value)
        _to(value) or fail ArgumentError, "Unknown value for to: #{value}"
      end

      # @private
      def _to(value)
        defined?(super) && super || ["html", "wikitext"].include?(value.to_s) && merge(to: value.to_s)
      end

      # Content to be converted.
      #
      # @param value [String]
      # @return [self]
      def content(value)
        merge(content: value.to_s)
      end

      # Title of the page. Cannot be used together with pageid.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(title: value.to_s)
      end

      # ID of the page. Cannot be used together with title.
      #
      # @param value [Integer]
      # @return [self]
      def pageid(value)
        merge(pageid: value.to_s)
      end
    end
  end
end
