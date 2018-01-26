# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Retrieve localized JSON data.
    #
    # Usage:
    #
    # ```ruby
    # api.jsondata.title(value).perform # returns string with raw output
    # # or
    # api.jsondata.title(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Jsondata < Reality::Describers::Wikidata::Impl::Actions::Get

      # Title to get. By default assumes namespace to be "Data:"
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(title: value.to_s)
      end
    end
  end
end
