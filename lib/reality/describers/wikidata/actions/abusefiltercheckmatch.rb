# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Check to see if an AbuseFilter matches a set of variables, editor logged AbuseFilter event.
    #
    # Usage:
    #
    # ```ruby
    # api.abusefiltercheckmatch.filter(value).perform # returns string with raw output
    # # or
    # api.abusefiltercheckmatch.filter(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Abusefiltercheckmatch < Reality::Describers::Wikidata::Impl::Actions::Get

      # The full filter text to check for a match.
      #
      # @param value [String]
      # @return [self]
      def filter(value)
        merge(filter: value.to_s)
      end

      # JSON encoded array of variables to test against.
      #
      # @param value [String]
      # @return [self]
      def vars(value)
        merge(vars: value.to_s)
      end

      # Recent change ID to check against.
      #
      # @param value [Integer]
      # @return [self]
      def rcid(value)
        merge(rcid: value.to_s)
      end

      # Abuse filter log ID to check against.
      #
      # @param value [Integer]
      # @return [self]
      def logid(value)
        merge(logid: value.to_s)
      end
    end
  end
end
