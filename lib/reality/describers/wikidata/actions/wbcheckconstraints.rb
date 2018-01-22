# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Performs constraint checks on any entity you want and returns the result.
    #
    # Usage:
    #
    # ```ruby
    # api.wbcheckconstraints.id(value).perform # returns string with raw output
    # # or
    # api.wbcheckconstraints.id(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Wbcheckconstraints < Reality::DataSources::Wikidata::Impl::Actions::Get

      # ID list of the entities to get the data from. Separate values with '|' or alternative.
      #
      # @param values [Array<String>]
      # @return [self]
      def id(*values)
        values.inject(self) { |res, val| res._id(val) }
      end

      # @private
      def _id(value)
        merge(id: value.to_s, replace: false)
      end

      # GUID list identifying a claim to check a constraint report.  Separate values with '|'.
      #
      # @param values [Array<String>]
      # @return [self]
      def claimid(*values)
        values.inject(self) { |res, val| res._claimid(val) }
      end

      # @private
      def _claimid(value)
        merge(claimid: value.to_s, replace: false)
      end

      # Optional filter to return only the constraints that have the specified constraint ID
      #
      # @param values [Array<String>]
      # @return [self]
      def constraintid(*values)
        values.inject(self) { |res, val| res._constraintid(val) }
      end

      # @private
      def _constraintid(value)
        merge(constraintid: value.to_s, replace: false)
      end
    end
  end
end
