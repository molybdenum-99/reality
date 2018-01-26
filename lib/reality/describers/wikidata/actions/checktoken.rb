# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Check the validity of a token from action=query&meta=tokens.
    #
    # Usage:
    #
    # ```ruby
    # api.checktoken.type(value).perform # returns string with raw output
    # # or
    # api.checktoken.type(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Checktoken < Reality::Describers::Wikidata::Impl::Actions::Get

      # Type of token being tested.
      #
      # @param value [String] One of "createaccount", "csrf", "deleteglobalaccount", "login", "patrol", "rollback", "setglobalaccountstatus", "userrights", "watch".
      # @return [self]
      def type(value)
        _type(value) or fail ArgumentError, "Unknown value for type: #{value}"
      end

      # @private
      def _type(value)
        defined?(super) && super || ["createaccount", "csrf", "deleteglobalaccount", "login", "patrol", "rollback", "setglobalaccountstatus", "userrights", "watch"].include?(value.to_s) && merge(type: value.to_s)
      end

      # Token to test.
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end

      # Maximum allowed age of the token, in seconds.
      #
      # @param value [Integer]
      # @return [self]
      def maxtokenage(value)
        merge(maxtokenage: value.to_s)
      end
    end
  end
end
