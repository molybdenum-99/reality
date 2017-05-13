# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Removes Wikibase claims.
    #
    # Usage:
    #
    # ```ruby
    # api.wbremoveclaims.claim(value).perform # returns string with raw output
    # # or
    # api.wbremoveclaims.claim(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Wbremoveclaims < Reality::DataSources::Wikidata::Impl::Actions::Post

      # One GUID or several (pipe-separated) GUIDs identifying the claims to be removed. All claims must belong to the same entity.
      #
      # @param values [Array<String>]
      # @return [self]
      def claim(*values)
        values.inject(self) { |res, val| res._claim(val) }
      end

      # @private
      def _claim(value)
        merge(claim: value.to_s, replace: false)
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

      # Mark this edit as bot. This URL flag will only be respected if the user belongs to the group "bot".
      #
      # @return [self]
      def bot()
        merge(bot: 'true')
      end
    end
  end
end
