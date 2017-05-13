# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Creates a qualifier or sets the value of an existing one.
    #
    # Usage:
    #
    # ```ruby
    # api.wbsetqualifier.claim(value).perform # returns string with raw output
    # # or
    # api.wbsetqualifier.claim(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Wbsetqualifier < Reality::DataSources::Wikidata::Impl::Actions::Post

      # A GUID identifying the claim for which a qualifier is being set
      #
      # @param value [String]
      # @return [self]
      def claim(value)
        merge(claim: value.to_s)
      end

      # ID of the snaks property. Should only be provided when creating a new qualifier or changing the property of an existing one
      #
      # @param value [String]
      # @return [self]
      def property(value)
        merge(property: value.to_s)
      end

      # The new value of the qualifier. Should only be provided for PropertyValueSnak qualifiers
      #
      # @param value [String]
      # @return [self]
      def value(value)
        merge(value: value.to_s)
      end

      # The type of the snak. Should only be provided when creating a new qualifier or changing the type of an existing one
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

      # The hash of the snak to modify. Should only be provided for existing qualifiers
      #
      # @param value [String]
      # @return [self]
      def snakhash(value)
        merge(snakhash: value.to_s)
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
