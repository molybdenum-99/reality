# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Get tokens for data-modifying actions.
    #
    # Usage:
    #
    # ```ruby
    # api.tokens.type(value).perform # returns string with raw output
    # # or
    # api.tokens.type(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Tokens < Reality::Describers::Wikidata::Impl::Actions::Get

      # Types of token to request.
      #
      # @param values [Array<String>] Allowed values: "block", "createaccount", "csrf", "delete", "deleteglobalaccount", "edit", "email", "import", "login", "move", "options", "patrol", "protect", "rollback", "setglobalaccountstatus", "unblock", "userrights", "watch".
      # @return [self]
      def type(*values)
        values.inject(self) { |res, val| res._type(val) or fail ArgumentError, "Unknown value for type: #{val}" }
      end

      # @private
      def _type(value)
        defined?(super) && super || ["block", "createaccount", "csrf", "delete", "deleteglobalaccount", "edit", "email", "import", "login", "move", "options", "patrol", "protect", "rollback", "setglobalaccountstatus", "unblock", "userrights", "watch"].include?(value.to_s) && merge(type: value.to_s, replace: false)
      end
    end
  end
end
