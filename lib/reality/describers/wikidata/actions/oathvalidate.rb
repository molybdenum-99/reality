# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Validate a two-factor authentication (OATH) token.
    #
    # Usage:
    #
    # ```ruby
    # api.oathvalidate.user(value).perform # returns string with raw output
    # # or
    # api.oathvalidate.user(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Oathvalidate < Reality::Describers::Wikidata::Impl::Actions::Post

      # User to validate token for. Defaults to the current user.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(user: value.to_s)
      end

      # Two-factor authentication (OATH) token.
      #
      # @param value [String]
      # @return [self]
      def totp(value)
        merge(totp: value.to_s)
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
