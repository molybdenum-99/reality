# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Send a password reset email to a user.
    #
    # Usage:
    #
    # ```ruby
    # api.resetpassword.user(value).perform # returns string with raw output
    # # or
    # api.resetpassword.user(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Resetpassword < Reality::DataSources::Wikidata::Impl::Actions::Post

      # User being reset.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(user: value.to_s)
      end

      # Email address of the user being reset.
      #
      # @param value [String]
      # @return [self]
      def email(value)
        merge(email: value.to_s)
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
