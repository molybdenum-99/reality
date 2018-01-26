# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Unblock a user.
    #
    # Usage:
    #
    # ```ruby
    # api.unblock.id(value).perform # returns string with raw output
    # # or
    # api.unblock.id(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Unblock < Reality::Describers::Wikidata::Impl::Actions::Post

      # ID of the block to unblock (obtained through list=blocks). Cannot be used together with user or userid.
      #
      # @param value [Integer]
      # @return [self]
      def id(value)
        merge(id: value.to_s)
      end

      # Username, IP address or IP address range to unblock. Cannot be used together with id or userid.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(user: value.to_s)
      end

      # User ID to unblock. Cannot be used together with id or user.
      #
      # @param value [Integer]
      # @return [self]
      def userid(value)
        merge(userid: value.to_s)
      end

      # Reason for unblock.
      #
      # @param value [String]
      # @return [self]
      def reason(value)
        merge(reason: value.to_s)
      end

      # Change tags to apply to the entry in the block log.
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
