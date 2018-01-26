# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Send a message to a list of pages.
    #
    # Usage:
    #
    # ```ruby
    # api.massmessage.spamlist(value).perform # returns string with raw output
    # # or
    # api.massmessage.spamlist(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Massmessage < Reality::Describers::Wikidata::Impl::Actions::Post

      # Page containing list of pages to leave a message on.
      #
      # @param value [String]
      # @return [self]
      def spamlist(value)
        merge(spamlist: value.to_s)
      end

      # Subject line of the message.
      #
      # @param value [String]
      # @return [self]
      def subject(value)
        merge(subject: value.to_s)
      end

      # Message body text.
      #
      # @param value [String]
      # @return [self]
      def message(value)
        merge(message: value.to_s)
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
