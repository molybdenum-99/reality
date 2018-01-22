# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Creates a reference or sets the value of an existing one.
    #
    # Usage:
    #
    # ```ruby
    # api.wbsetreference.statement(value).perform # returns string with raw output
    # # or
    # api.wbsetreference.statement(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Wbsetreference < Reality::DataSources::Wikidata::Impl::Actions::Post

      # A GUID identifying the statement for which a reference is being set
      #
      # @param value [String]
      # @return [self]
      def statement(value)
        merge(statement: value.to_s)
      end

      # The snaks to set the reference to. JSON object with property IDs pointing to arrays containing the snaks for that property
      #
      # @param value [String]
      # @return [self]
      def snaks(value)
        merge(snaks: value.to_s)
      end

      # The order of the snaks. JSON array of property ID strings
      #
      # @param value [String]
      # @return [self]
      def snaks_order(value)
        merge('snaks-order': value.to_s)
      end

      # A hash of the reference that should be updated. Optional. When not provided, a new reference is created
      #
      # @param value [String]
      # @return [self]
      def reference(value)
        merge(reference: value.to_s)
      end

      # The index within the statement's list of references where to move the reference to. Optional. When not provided, an existing reference will stay in place while a new reference will be appended.
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

      # Mark this edit as bot. This URL flag will only be respected if the user belongs to the group "bot".
      #
      # @return [self]
      def bot()
        merge(bot: 'true')
      end
    end
  end
end
