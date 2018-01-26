# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Send a public thank-you notification for a Flow comment.
    #
    # Usage:
    #
    # ```ruby
    # api.flowthank.postid(value).perform # returns string with raw output
    # # or
    # api.flowthank.postid(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Flowthank < Reality::Describers::Wikidata::Impl::Actions::Post

      # The UUID of the post to thank for.
      #
      # @param value [String]
      # @return [self]
      def postid(value)
        merge(postid: value.to_s)
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
