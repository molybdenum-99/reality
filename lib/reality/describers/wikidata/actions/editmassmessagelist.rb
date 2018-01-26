# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Edit a mass message delivery list.
    #
    # Usage:
    #
    # ```ruby
    # api.editmassmessagelist.spamlist(value).perform # returns string with raw output
    # # or
    # api.editmassmessagelist.spamlist(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Editmassmessagelist < Reality::Describers::Wikidata::Impl::Actions::Post

      # Title of the delivery list to update.
      #
      # @param value [String]
      # @return [self]
      def spamlist(value)
        merge(spamlist: value.to_s)
      end

      # Titles to add to the list.
      #
      # @param values [Array<String>]
      # @return [self]
      def add(*values)
        values.inject(self) { |res, val| res._add(val) }
      end

      # @private
      def _add(value)
        merge(add: value.to_s, replace: false)
      end

      # Titles to remove from the list.
      #
      # @param values [Array<String>]
      # @return [self]
      def remove(*values)
        values.inject(self) { |res, val| res._remove(val) }
      end

      # @private
      def _remove(value)
        merge(remove: value.to_s, replace: false)
      end

      # A "csrf" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end
    end
  end
end
