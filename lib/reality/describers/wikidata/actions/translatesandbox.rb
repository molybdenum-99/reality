# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Signup and manage sandboxed users.
    #
    # Usage:
    #
    # ```ruby
    # api.translatesandbox.do(value).perform # returns string with raw output
    # # or
    # api.translatesandbox.do(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Translatesandbox < Reality::DataSources::Wikidata::Impl::Actions::Post

      # What to do.
      #
      # @param value [String] One of "create", "delete", "promote", "remind".
      # @return [self]
      def do(value)
        _do(value) or fail ArgumentError, "Unknown value for do: #{value}"
      end

      # @private
      def _do(value)
        defined?(super) && super || ["create", "delete", "promote", "remind"].include?(value.to_s) && merge(do: value.to_s)
      end

      # User IDs of the users being managed. Use 0 for creations.
      #
      # @param values [Array<Integer>]
      # @return [self]
      def userid(*values)
        values.inject(self) { |res, val| res._userid(val) }
      end

      # @private
      def _userid(value)
        merge(userid: value.to_s, replace: false)
      end

      # A "csrf" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end

      # Username when creating user.
      #
      # @param value [String]
      # @return [self]
      def username(value)
        merge(username: value.to_s)
      end

      # Password when creating user.
      #
      # @param value [String]
      # @return [self]
      def password(value)
        merge(password: value.to_s)
      end

      # Email when creating user.
      #
      # @param value [String]
      # @return [self]
      def email(value)
        merge(email: value.to_s)
      end
    end
  end
end
