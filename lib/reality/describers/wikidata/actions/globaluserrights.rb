# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Add/remove a user to/from global groups.
    #
    # Usage:
    #
    # ```ruby
    # api.globaluserrights.user(value).perform # returns string with raw output
    # # or
    # api.globaluserrights.user(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Globaluserrights < Reality::Describers::Wikidata::Impl::Actions::Post

      # Global user name.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(user: value.to_s)
      end

      # Global user ID.
      #
      # @param value [Integer]
      # @return [self]
      def userid(value)
        merge(userid: value.to_s)
      end

      # Add the user to these global groups.
      #
      # @param values [Array<String>] Allowed values: "OTRS-member", "abusefilter-helper", "apihighlimits-requestor", "captcha-exempt", "delete-global", "founder", "global-bot", "global-flow-create", "global-interface-editor", "global-ipblock-exempt", "global-rollbacker", "global-sysop", "new-wikis-importer", "oathauth-tester", "ombudsman", "recursive-export", "staff", "steward", "sysadmin", "wmf-ops-monitoring", "wmf-researcher".
      # @return [self]
      def add(*values)
        values.inject(self) { |res, val| res._add(val) or fail ArgumentError, "Unknown value for add: #{val}" }
      end

      # @private
      def _add(value)
        defined?(super) && super || ["OTRS-member", "abusefilter-helper", "apihighlimits-requestor", "captcha-exempt", "delete-global", "founder", "global-bot", "global-flow-create", "global-interface-editor", "global-ipblock-exempt", "global-rollbacker", "global-sysop", "new-wikis-importer", "oathauth-tester", "ombudsman", "recursive-export", "staff", "steward", "sysadmin", "wmf-ops-monitoring", "wmf-researcher"].include?(value.to_s) && merge(add: value.to_s, replace: false)
      end

      # Remove the user from these global groups.
      #
      # @param values [Array<String>] Allowed values: "OTRS-member", "abusefilter-helper", "apihighlimits-requestor", "captcha-exempt", "delete-global", "founder", "global-bot", "global-flow-create", "global-interface-editor", "global-ipblock-exempt", "global-rollbacker", "global-sysop", "new-wikis-importer", "oathauth-tester", "ombudsman", "recursive-export", "staff", "steward", "sysadmin", "wmf-ops-monitoring", "wmf-researcher".
      # @return [self]
      def remove(*values)
        values.inject(self) { |res, val| res._remove(val) or fail ArgumentError, "Unknown value for remove: #{val}" }
      end

      # @private
      def _remove(value)
        defined?(super) && super || ["OTRS-member", "abusefilter-helper", "apihighlimits-requestor", "captcha-exempt", "delete-global", "founder", "global-bot", "global-flow-create", "global-interface-editor", "global-ipblock-exempt", "global-rollbacker", "global-sysop", "new-wikis-importer", "oathauth-tester", "ombudsman", "recursive-export", "staff", "steward", "sysadmin", "wmf-ops-monitoring", "wmf-researcher"].include?(value.to_s) && merge(remove: value.to_s, replace: false)
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

      # This parameter is currently unused.
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
