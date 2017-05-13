# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Creates Wikibase claims.
    #
    # Usage:
    #
    # ```ruby
    # api.wbcreateclaim.entity(value).perform # returns string with raw output
    # # or
    # api.wbcreateclaim.entity(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Wbcreateclaim < Reality::DataSources::Wikidata::Impl::Actions::Post

      # ID of the entity the claim is being added to
      #
      # @param value [String]
      # @return [self]
      def entity(value)
        merge(entity: value.to_s)
      end

      # The type of the snak
      #
      # @param value [String] One of "value", "novalue", "somevalue".
      # @return [self]
      def snaktype(value)
        _snaktype(value) or fail ArgumentError, "Unknown value for snaktype: #{value}"
      end

      # @private
      def _snaktype(value)
        defined?(super) && super || ["value", "novalue", "somevalue"].include?(value.to_s) && merge(snaktype: value.to_s)
      end

      # ID of the snaks property
      #
      # @param value [String]
      # @return [self]
      def property(value)
        merge(property: value.to_s)
      end

      # Value of the snak when creating a claim with a snak that has a value
      #
      # @param value [String]
      # @return [self]
      def value(value)
        merge(value: value.to_s)
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
