# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Create a new user account.
    #
    # Usage:
    #
    # ```ruby
    # api.createaccount.requests(value).perform # returns string with raw output
    # # or
    # api.createaccount.requests(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Createaccount < Reality::Describers::Wikidata::Impl::Actions::Post

      # Only use these authentication requests, by the id returned from action=query&meta=authmanagerinfo with amirequestsfor=create or from a previous response from this module.
      #
      # @param values [Array<String>]
      # @return [self]
      def requests(*values)
        values.inject(self) { |res, val| res._requests(val) }
      end

      # @private
      def _requests(value)
        merge(createrequests: value.to_s, replace: false)
      end

      # Format to use for returning messages.
      #
      # @param value [String] One of "html", "wikitext", "raw", "none".
      # @return [self]
      def messageformat(value)
        _messageformat(value) or fail ArgumentError, "Unknown value for messageformat: #{value}"
      end

      # @private
      def _messageformat(value)
        defined?(super) && super || ["html", "wikitext", "raw", "none"].include?(value.to_s) && merge(createmessageformat: value.to_s)
      end

      # Merge field information for all authentication requests into one array.
      #
      # @return [self]
      def mergerequestfields()
        merge(createmergerequestfields: 'true')
      end

      # Preserve state from a previous failed login attempt, if possible.
      #
      # @return [self]
      def preservestate()
        merge(createpreservestate: 'true')
      end

      # Return URL for third-party authentication flows, must be absolute. Either this or createcontinue is required.
      #
      # @param value [String]
      # @return [self]
      def returnurl(value)
        merge(createreturnurl: value.to_s)
      end

      # This request is a continuation after an earlier UI or REDIRECT response. Either this or createreturnurl is required.
      #
      # @return [self]
      def continue()
        merge(createcontinue: 'true')
      end

      # A "createaccount" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(createtoken: value.to_s)
      end
    end
  end
end
