# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Allows admins to strike or unstrike a vote.
    #
    # Usage:
    #
    # ```ruby
    # api.strikevote.option(value).perform # returns string with raw output
    # # or
    # api.strikevote.option(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Strikevote < Reality::Describers::Wikidata::Impl::Actions::Post

      # Which action to take: strike or unstrike a vote.
      #
      # @param value [String] One of "strike" (Strike a vote (remove it from the count)), "unstrike" (Unstrike a vote (restore it to the count)).
      # @return [self]
      def option(value)
        _option(value) or fail ArgumentError, "Unknown value for option: #{value}"
      end

      # @private
      def _option(value)
        defined?(super) && super || ["strike", "unstrike"].include?(value.to_s) && merge(option: value.to_s)
      end

      # The reason for striking or unstriking the vote.
      #
      # @param value [String]
      # @return [self]
      def reason(value)
        merge(reason: value.to_s)
      end

      # The ID of the vote to be struck or unstruck.
      #
      # @param value [Integer]
      # @return [self]
      def voteid(value)
        merge(voteid: value.to_s)
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
