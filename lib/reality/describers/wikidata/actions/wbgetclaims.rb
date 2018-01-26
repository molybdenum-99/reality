# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Gets Wikibase claims.
    #
    # Usage:
    #
    # ```ruby
    # api.wbgetclaims.entity(value).perform # returns string with raw output
    # # or
    # api.wbgetclaims.entity(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Wbgetclaims < Reality::Describers::Wikidata::Impl::Actions::Get

      # ID of the entity from which to obtain claims. Required unless claim GUID is provided.
      #
      # @param value [String]
      # @return [self]
      def entity(value)
        merge(entity: value.to_s)
      end

      # Optional filter to only return claims with a main snak that has the specified property.
      #
      # @param value [String]
      # @return [self]
      def property(value)
        merge(property: value.to_s)
      end

      # A GUID identifying the claim. Required unless entity is provided. The GUID is the globally unique identifier for a claim, e.g. "q42$D8404CDA-25E4-4334-AF13-A3290BCD9C0F".
      #
      # @param value [String]
      # @return [self]
      def claim(value)
        merge(claim: value.to_s)
      end

      # Optional filter to return only the claims that have the specified rank
      #
      # @param value [String] One of "deprecated", "normal", "preferred".
      # @return [self]
      def rank(value)
        _rank(value) or fail ArgumentError, "Unknown value for rank: #{value}"
      end

      # @private
      def _rank(value)
        defined?(super) && super || ["deprecated", "normal", "preferred"].include?(value.to_s) && merge(rank: value.to_s)
      end

      # Some parts of the claim are returned optionally. This parameter controls which ones are returned.
      #
      # @param values [Array<String>] Allowed values: "references".
      # @return [self]
      def props(*values)
        values.inject(self) { |res, val| res._props(val) or fail ArgumentError, "Unknown value for props: #{val}" }
      end

      # @private
      def _props(value)
        defined?(super) && super || ["references"].include?(value.to_s) && merge(props: value.to_s, replace: false)
      end
    end
  end
end
