# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Block a user.
    #
    # Usage:
    #
    # ```ruby
    # api.block.user(value).perform # returns string with raw output
    # # or
    # api.block.user(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Block < Reality::Describers::Wikidata::Impl::Actions::Post

      # Username, IP address, or IP address range to block. Cannot be used together with userid
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(user: value.to_s)
      end

      # User ID to block. Cannot be used together with user.
      #
      # @param value [Integer]
      # @return [self]
      def userid(value)
        merge(userid: value.to_s)
      end

      # Expiry time. May be relative (e.g. 5 months or 2 weeks) or absolute (e.g. 2014-09-18T12:34:56Z). If set to infinite, indefinite, or never, the block will never expire.
      #
      # @param value [String]
      # @return [self]
      def expiry(value)
        merge(expiry: value.to_s)
      end

      # Reason for block.
      #
      # @param value [String]
      # @return [self]
      def reason(value)
        merge(reason: value.to_s)
      end

      # Block anonymous users only (i.e. disable anonymous edits for this IP address).
      #
      # @return [self]
      def anononly()
        merge(anononly: 'true')
      end

      # Prevent account creation.
      #
      # @return [self]
      def nocreate()
        merge(nocreate: 'true')
      end

      # Automatically block the last used IP address, and any subsequent IP addresses they try to login from.
      #
      # @return [self]
      def autoblock()
        merge(autoblock: 'true')
      end

      # Prevent user from sending email through the wiki. (Requires the blockemail right).
      #
      # @return [self]
      def noemail()
        merge(noemail: 'true')
      end

      # Hide the username from the block log. (Requires the hideuser right).
      #
      # @return [self]
      def hidename()
        merge(hidename: 'true')
      end

      # Allow the user to edit their own talk page (depends on $wgBlockAllowsUTEdit).
      #
      # @return [self]
      def allowusertalk()
        merge(allowusertalk: 'true')
      end

      # If the user is already blocked, overwrite the existing block.
      #
      # @return [self]
      def reblock()
        merge(reblock: 'true')
      end

      # Watch the user's or IP address's user and talk pages.
      #
      # @return [self]
      def watchuser()
        merge(watchuser: 'true')
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
