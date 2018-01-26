# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Removes a qualifier from a claim.
    #
    # Usage:
    #
    # ```ruby
    # api.wbremovequalifiers.claim(value).perform # returns string with raw output
    # # or
    # api.wbremovequalifiers.claim(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Wbremovequalifiers < Reality::Describers::Wikidata::Impl::Actions::Post

      # A GUID identifying the claim from which to remove qualifiers
      #
      # @param value [String]
      # @return [self]
      def claim(value)
        merge(claim: value.to_s)
      end

      # Snak hashes of the qualifiers to remove
      #
      # @param values [Array<String>]
      # @return [self]
      def qualifiers(*values)
        values.inject(self) { |res, val| res._qualifiers(val) }
      end

      # @private
      def _qualifiers(value)
        merge(qualifiers: value.to_s, replace: false)
      end

      # Summary for the edit. Will be prepended by an automatically generated comment. The length limit of the autocomment together with the summary is 260 characters. Be aware that everything above that limit will be cut off.
      #
      # @param value [String]
      # @return [self]
      def summary(value)
        merge(summary: value.to_s)
      end

      # A "csrf" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end

      # The numeric identifier for the revision to base the modification on. This is used for detecting conflicts during save.
      #
      # @param value [Integer]
      # @return [self]
      def baserevid(value)
        merge(baserevid: value.to_s)
      end

      # Mark this edit as bot. This URL flag will only be respected if the user belongs to the group "Bots".
      #
      # @return [self]
      def bot()
        merge(bot: 'true')
      end
    end
  end
end
