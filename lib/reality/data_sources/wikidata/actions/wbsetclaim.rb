# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Creates or updates an entire Statement or Claim.
    #
    # Usage:
    #
    # ```ruby
    # api.wbsetclaim.claim(value).perform # returns string with raw output
    # # or
    # api.wbsetclaim.claim(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Wbsetclaim < Reality::DataSources::Wikidata::Impl::Actions::Post

      # Statement or Claim serialization
      #
      # @param value [String]
      # @return [self]
      def claim(value)
        merge(claim: value.to_s)
      end

      # The index within the entity's list of statements to move the statement to. Optional. Be aware that when setting an index that specifies a position not next to a statement whose main snak does not feature the same property, the whole group of statements whose main snaks feature the same property is moved. When not provided, an existing statement will stay in place while a new statement will be appended to the last one whose main snak features the same property.
      #
      # @param value [Integer]
      # @return [self]
      def index(value)
        merge(index: value.to_s)
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
