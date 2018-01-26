# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Change a user's group membership.
    #
    # Usage:
    #
    # ```ruby
    # api.userrights.user(value).perform # returns string with raw output
    # # or
    # api.userrights.user(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Userrights < Reality::Describers::Wikidata::Impl::Actions::Post

      # User name.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(user: value.to_s)
      end

      # User ID.
      #
      # @param value [Integer]
      # @return [self]
      def userid(value)
        merge(userid: value.to_s)
      end

      # Add the user to these groups, or if they are already a member, update the expiry of their membership in that group.
      #
      # @param values [Array<String>] Allowed values: "bot", "sysop", "bureaucrat", "steward", "accountcreator", "import", "transwiki", "ipblock-exempt", "oversight", "rollbacker", "propertycreator", "wikidata-staff", "flood", "translationadmin", "confirmed", "flow-bot", "checkuser".
      # @return [self]
      def add(*values)
        values.inject(self) { |res, val| res._add(val) or fail ArgumentError, "Unknown value for add: #{val}" }
      end

      # @private
      def _add(value)
        defined?(super) && super || ["bot", "sysop", "bureaucrat", "steward", "accountcreator", "import", "transwiki", "ipblock-exempt", "oversight", "rollbacker", "propertycreator", "wikidata-staff", "flood", "translationadmin", "confirmed", "flow-bot", "checkuser"].include?(value.to_s) && merge(add: value.to_s, replace: false)
      end

      # Expiry timestamps. May be relative (e.g. 5 months or 2 weeks) or absolute (e.g. 2014-09-18T12:34:56Z). If only one timestamp is set, it will be used for all groups passed to the add parameter. Use infinite, indefinite, infinity, or never for a never-expiring user group.
      #
      # @param values [Array<String>]
      # @return [self]
      def expiry(*values)
        values.inject(self) { |res, val| res._expiry(val) }
      end

      # @private
      def _expiry(value)
        merge(expiry: value.to_s, replace: false)
      end

      # Remove the user from these groups.
      #
      # @param values [Array<String>] Allowed values: "bot", "sysop", "bureaucrat", "steward", "accountcreator", "import", "transwiki", "ipblock-exempt", "oversight", "rollbacker", "propertycreator", "wikidata-staff", "flood", "translationadmin", "confirmed", "flow-bot", "checkuser".
      # @return [self]
      def remove(*values)
        values.inject(self) { |res, val| res._remove(val) or fail ArgumentError, "Unknown value for remove: #{val}" }
      end

      # @private
      def _remove(value)
        defined?(super) && super || ["bot", "sysop", "bureaucrat", "steward", "accountcreator", "import", "transwiki", "ipblock-exempt", "oversight", "rollbacker", "propertycreator", "wikidata-staff", "flood", "translationadmin", "confirmed", "flow-bot", "checkuser"].include?(value.to_s) && merge(remove: value.to_s, replace: false)
      end

      # Reason for the change.
      #
      # @param value [String]
      # @return [self]
      def reason(value)
        merge(reason: value.to_s)
      end

      # A "userrights" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end

      # Change tags to apply to the entry in the user rights log.
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
    end
  end
end
