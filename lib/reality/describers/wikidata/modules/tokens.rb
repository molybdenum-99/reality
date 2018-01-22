# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Gets tokens for data-modifying actions.
    #
    # The "submodule" (MediaWiki API term) is included in action after setting some param, providing
    # additional tweaking for this param. Example (for {Reality::DataSources::Wikidata::Impl::Actions::Query} and
    # its submodules):
    #
    # ```ruby
    # api.query             # returns Actions::Query
    #    .prop(:revisions)  # adds prop=revisions to action URL, and includes Modules::Revisions into action
    #    .limit(10)         # method of Modules::Revisions, adds rvlimit=10 to URL
    # ```
    #
    # All submodule's parameters are documented as its public methods, see below.
    #
    module Tokens

      # Types of token to request.
      #
      # @param values [Array<String>] Allowed values: "createaccount", "csrf", "deleteglobalaccount", "login", "patrol", "rollback", "setglobalaccountstatus", "userrights", "watch".
      # @return [self]
      def type(*values)
        values.inject(self) { |res, val| res._type(val) or fail ArgumentError, "Unknown value for type: #{val}" }
      end

      # @private
      def _type(value)
        defined?(super) && super || ["createaccount", "csrf", "deleteglobalaccount", "login", "patrol", "rollback", "setglobalaccountstatus", "userrights", "watch"].include?(value.to_s) && merge(type: value.to_s, replace: false)
      end
    end
  end
end
