# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Receive a bounce email and process it to handle the failing recipient.
    #
    # Usage:
    #
    # ```ruby
    # api.bouncehandler.email(value).perform # returns string with raw output
    # # or
    # api.bouncehandler.email(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Bouncehandler < Reality::DataSources::Wikidata::Impl::Actions::Post

      # The bounced email.
      #
      # @param value [String]
      # @return [self]
      def email(value)
        merge(email: value.to_s)
      end
    end
  end
end
