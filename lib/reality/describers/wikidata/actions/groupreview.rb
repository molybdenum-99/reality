# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Set message group workflow states.
    #
    # Usage:
    #
    # ```ruby
    # api.groupreview.group(value).perform # returns string with raw output
    # # or
    # api.groupreview.group(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Groupreview < Reality::Describers::Wikidata::Impl::Actions::Post

      # Message group.
      #
      # @param value [String]
      # @return [self]
      def group(value)
        merge(group: value.to_s)
      end

      # Language code.
      #
      # @param value [String]
      # @return [self]
      def language(value)
        merge(language: value.to_s)
      end

      # The new state for the group.
      #
      # @param value [String]
      # @return [self]
      def state(value)
        merge(state: value.to_s)
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
