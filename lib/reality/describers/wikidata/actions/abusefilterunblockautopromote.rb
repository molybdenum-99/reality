# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Unblocks a user from receiving autopromotions due to an abusefilter consequence.
    #
    # Usage:
    #
    # ```ruby
    # api.abusefilterunblockautopromote.user(value).perform # returns string with raw output
    # # or
    # api.abusefilterunblockautopromote.user(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Abusefilterunblockautopromote < Reality::Describers::Wikidata::Impl::Actions::Post

      # Username of the user you want to unblock.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(user: value.to_s)
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
