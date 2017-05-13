# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Delete a global user.
    #
    # Usage:
    #
    # ```ruby
    # api.deleteglobalaccount.user(value).perform # returns string with raw output
    # # or
    # api.deleteglobalaccount.user(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Deleteglobalaccount < Reality::DataSources::Wikidata::Impl::Actions::Post

      # User to delete.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(user: value.to_s)
      end

      # Reason for deleting the user.
      #
      # @param value [String]
      # @return [self]
      def reason(value)
        merge(reason: value.to_s)
      end

      # A "deleteglobalaccount" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end
    end
  end
end
