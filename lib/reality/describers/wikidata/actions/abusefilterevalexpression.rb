# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Evaluates an AbuseFilter expression.
    #
    # Usage:
    #
    # ```ruby
    # api.abusefilterevalexpression.expression(value).perform # returns string with raw output
    # # or
    # api.abusefilterevalexpression.expression(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Abusefilterevalexpression < Reality::Describers::Wikidata::Impl::Actions::Get

      # The expression to evaluate.
      #
      # @param value [String]
      # @return [self]
      def expression(value)
        merge(expression: value.to_s)
      end
    end
  end
end
