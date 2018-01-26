# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Patrol a page or revision.
    #
    # Usage:
    #
    # ```ruby
    # api.patrol.rcid(value).perform # returns string with raw output
    # # or
    # api.patrol.rcid(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Patrol < Reality::Describers::Wikidata::Impl::Actions::Post

      # Recentchanges ID to patrol.
      #
      # @param value [Integer]
      # @return [self]
      def rcid(value)
        merge(rcid: value.to_s)
      end

      # Revision ID to patrol.
      #
      # @param value [Integer]
      # @return [self]
      def revid(value)
        merge(revid: value.to_s)
      end

      # Change tags to apply to the entry in the patrol log.
      #
      # @param values [Array<String>] Allowed values: "InfoboxExport gadget", "WE-Framework gadget".
      # @return [self]
      def tags(*values)
        values.inject(self) { |res, val| res._tags(val) or fail ArgumentError, "Unknown value for tags: #{val}" }
      end

      # @private
      def _tags(value)
        defined?(super) && super || ["InfoboxExport gadget", "WE-Framework gadget"].include?(value.to_s) && merge(tags: value.to_s, replace: false)
      end

      # A "patrol" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end
    end
  end
end
