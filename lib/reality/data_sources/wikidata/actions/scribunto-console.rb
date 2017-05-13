# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Internal module for servicing XHR requests from the Scribunto console.
    #
    # Usage:
    #
    # ```ruby
    # api.scribunto-console.title(value).perform # returns string with raw output
    # # or
    # api.scribunto-console.title(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class ScribuntoConsole < Reality::DataSources::Wikidata::Impl::Actions::Get

      # The title of the module to test.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(title: value.to_s)
      end

      # The new content of the module.
      #
      # @param value [String]
      # @return [self]
      def content(value)
        merge(content: value.to_s)
      end

      # Session token.
      #
      # @param value [Integer]
      # @return [self]
      def session(value)
        merge(session: value.to_s)
      end

      # The next line to evaluate as a script.
      #
      # @param value [String]
      # @return [self]
      def question(value)
        merge(question: value.to_s)
      end

      # Set to clear the current session state.
      #
      # @return [self]
      def clear()
        merge(clear: 'true')
      end
    end
  end
end
