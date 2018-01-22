# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Access graph tag functionality.
    #
    # Usage:
    #
    # ```ruby
    # api.graph.hash(value).perform # returns string with raw output
    # # or
    # api.graph.hash(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Graph < Reality::DataSources::Wikidata::Impl::Actions::Get

      # Hash value of the graph
      #
      # @param value [String]
      # @return [self]
      def hash(value)
        merge(hash: value.to_s)
      end

      # Title of the article with the graph
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(title: value.to_s)
      end

      # Text of the graph to be converted to JSON. Must be posted and used without title and hash parameters
      #
      # @param value [String]
      # @return [self]
      def text(value)
        merge(text: value.to_s)
      end
    end
  end
end
