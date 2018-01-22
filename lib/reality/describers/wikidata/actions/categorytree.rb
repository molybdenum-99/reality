# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Internal module for the CategoryTree extension.
    #
    # Usage:
    #
    # ```ruby
    # api.categorytree.category(value).perform # returns string with raw output
    # # or
    # api.categorytree.category(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Categorytree < Reality::DataSources::Wikidata::Impl::Actions::Get

      # Title in the category namespace, prefix will be ignored if given.
      #
      # @param value [String]
      # @return [self]
      def category(value)
        merge(category: value.to_s)
      end

      # Options for the CategoryTree constructor as a JSON object. The depth option defaults to 1.
      #
      # @param value [String]
      # @return [self]
      def options(value)
        merge(options: value.to_s)
      end
    end
  end
end
