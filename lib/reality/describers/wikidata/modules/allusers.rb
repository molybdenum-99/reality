# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Enumerate all registered users.
    #
    # The "submodule" (MediaWiki API term) is included in action after setting some param, providing
    # additional tweaking for this param. Example (for {Reality::Describers::Wikidata::Impl::Actions::Query} and
    # its submodules):
    #
    # ```ruby
    # api.query             # returns Actions::Query
    #    .prop(:revisions)  # adds prop=revisions to action URL, and includes Modules::Revisions into action
    #    .limit(10)         # method of Modules::Revisions, adds rvlimit=10 to URL
    # ```
    #
    # All submodule's parameters are documented as its public methods, see below.
    #
    module Allusers

      # The user name to start enumerating from.
      #
      # @param value [String]
      # @return [self]
      def from(value)
        merge(aufrom: value.to_s)
      end

      # The user name to stop enumerating at.
      #
      # @param value [String]
      # @return [self]
      def to(value)
        merge(auto: value.to_s)
      end

      # Search for all users that begin with this value.
      #
      # @param value [String]
      # @return [self]
      def prefix(value)
        merge(auprefix: value.to_s)
      end

      # Direction to sort in.
      #
      # @param value [String] One of "ascending", "descending".
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["ascending", "descending"].include?(value.to_s) && merge(audir: value.to_s)
      end

      # Only include users in the given groups.
      #
      # @param values [Array<String>] Allowed values: "bot", "sysop", "bureaucrat", "steward", "accountcreator", "import", "transwiki", "ipblock-exempt", "oversight", "rollbacker", "propertycreator", "wikidata-staff", "flood", "translationadmin", "confirmed", "flow-bot", "checkuser".
      # @return [self]
      def group(*values)
        values.inject(self) { |res, val| res._group(val) or fail ArgumentError, "Unknown value for group: #{val}" }
      end

      # @private
      def _group(value)
        defined?(super) && super || ["bot", "sysop", "bureaucrat", "steward", "accountcreator", "import", "transwiki", "ipblock-exempt", "oversight", "rollbacker", "propertycreator", "wikidata-staff", "flood", "translationadmin", "confirmed", "flow-bot", "checkuser"].include?(value.to_s) && merge(augroup: value.to_s, replace: false)
      end

      # Exclude users in the given groups.
      #
      # @param values [Array<String>] Allowed values: "bot", "sysop", "bureaucrat", "steward", "accountcreator", "import", "transwiki", "ipblock-exempt", "oversight", "rollbacker", "propertycreator", "wikidata-staff", "flood", "translationadmin", "confirmed", "flow-bot", "checkuser".
      # @return [self]
      def excludegroup(*values)
        values.inject(self) { |res, val| res._excludegroup(val) or fail ArgumentError, "Unknown value for excludegroup: #{val}" }
      end

      # @private
      def _excludegroup(value)
        defined?(super) && super || ["bot", "sysop", "bureaucrat", "steward", "accountcreator", "import", "transwiki", "ipblock-exempt", "oversight", "rollbacker", "propertycreator", "wikidata-staff", "flood", "translationadmin", "confirmed", "flow-bot", "checkuser"].include?(value.to_s) && merge(auexcludegroup: value.to_s, replace: false)
      end

      # Only include users with the given rights. Does not include rights granted by implicit or auto-promoted groups like *, user, or autoconfirmed.
      #
      # @param values [Array<String>] Allowed values: "apihighlimits", "applychangetags", "autoconfirmed", "autocreateaccount", "autopatrol", "bigdelete", "block", "blockemail", "bot", "browsearchive", "changetags", "createaccount", "createpage", "createtalk", "delete", "deletechangetags", "deletedhistory", "deletedtext", "deletelogentry", "deleterevision", "edit", "editcontentmodel", "editinterface", "editprotected", "editmyoptions", "editmyprivateinfo", "editmyusercss", "editmyuserjs", "editmywatchlist", "editsemiprotected", "editusercss", "edituserjs", "hideuser", "import", "importupload", "ipblock-exempt", "managechangetags", "markbotedits", "mergehistory", "minoredit", "move", "movefile", "move-categorypages", "move-rootuserpages", "move-subpages", "nominornewtalk", "noratelimit", "override-export-depth", "pagelang", "patrol", "patrolmarks", "protect", "purge", "read", "reupload", "reupload-own", "reupload-shared", "rollback", "sendemail", "siteadmin", "suppressionlog", "suppressredirect", "suppressrevision", "unblockself", "undelete", "unwatchedpages", "upload", "upload_by_url", "userrights", "userrights-interwiki", "viewmyprivateinfo", "viewmywatchlist", "viewsuppressed", "writeapi", "spamblacklistlog", "tboverride", "tboverride-account", "titleblacklistlog", "gadgets-edit", "gadgets-definition-edit", "globalblock", "globalblock-whitelist", "globalblock-exempt", "securepoll-create-poll", "renameuser", "nuke", "torunblocked", "skipcaptcha", "override-antispoof", "centralauth-merge", "centralauth-unmerge", "centralauth-lock", "centralauth-oversight", "globalgrouppermissions", "globalgroupmembership", "centralauth-rename", "centralauth-usermerge", "abusefilter-modify", "abusefilter-log-detail", "abusefilter-view", "abusefilter-log", "abusefilter-private", "abusefilter-modify-restricted", "abusefilter-revert", "abusefilter-view-private", "abusefilter-log-private", "abusefilter-hidden-log", "abusefilter-hide-log", "abusefilter-modify-global", "massmessage", "vipsscaler-test", "flow-hide", "flow-lock", "flow-delete", "flow-suppress", "flow-edit-post", "flow-create-board", "usermerge", "mwoauthproposeconsumer", "mwoauthupdateownconsumer", "mwoauthmanageconsumer", "mwoauthsuppress", "mwoauthviewsuppressed", "mwoauthviewprivate", "mwoauthmanagemygrants", "oathauth-enable", "oathauth-api-all", "checkuser", "checkuser-log", "autoreviewrestore", "stablesettings", "review", "unreviewedpages", "movestable", "validate", "templateeditor", "editeditorprotected", "editextendedsemiprotected", "extendedconfirmed", "viewdeletedfile", "transcode-reset", "transcode-status", "collectionsaveasuserpage", "collectionsaveascommunitypage", "translate", "translate-import", "translate-manage", "translate-messagereview", "translate-groupreview", "item-term", "property-term", "item-merge", "item-redirect", "property-create", "pagetranslation".
      # @return [self]
      def rights(*values)
        values.inject(self) { |res, val| res._rights(val) or fail ArgumentError, "Unknown value for rights: #{val}" }
      end

      # @private
      def _rights(value)
        defined?(super) && super || ["apihighlimits", "applychangetags", "autoconfirmed", "autocreateaccount", "autopatrol", "bigdelete", "block", "blockemail", "bot", "browsearchive", "changetags", "createaccount", "createpage", "createtalk", "delete", "deletechangetags", "deletedhistory", "deletedtext", "deletelogentry", "deleterevision", "edit", "editcontentmodel", "editinterface", "editprotected", "editmyoptions", "editmyprivateinfo", "editmyusercss", "editmyuserjs", "editmywatchlist", "editsemiprotected", "editusercss", "edituserjs", "hideuser", "import", "importupload", "ipblock-exempt", "managechangetags", "markbotedits", "mergehistory", "minoredit", "move", "movefile", "move-categorypages", "move-rootuserpages", "move-subpages", "nominornewtalk", "noratelimit", "override-export-depth", "pagelang", "patrol", "patrolmarks", "protect", "purge", "read", "reupload", "reupload-own", "reupload-shared", "rollback", "sendemail", "siteadmin", "suppressionlog", "suppressredirect", "suppressrevision", "unblockself", "undelete", "unwatchedpages", "upload", "upload_by_url", "userrights", "userrights-interwiki", "viewmyprivateinfo", "viewmywatchlist", "viewsuppressed", "writeapi", "spamblacklistlog", "tboverride", "tboverride-account", "titleblacklistlog", "gadgets-edit", "gadgets-definition-edit", "globalblock", "globalblock-whitelist", "globalblock-exempt", "securepoll-create-poll", "renameuser", "nuke", "torunblocked", "skipcaptcha", "override-antispoof", "centralauth-merge", "centralauth-unmerge", "centralauth-lock", "centralauth-oversight", "globalgrouppermissions", "globalgroupmembership", "centralauth-rename", "centralauth-usermerge", "abusefilter-modify", "abusefilter-log-detail", "abusefilter-view", "abusefilter-log", "abusefilter-private", "abusefilter-modify-restricted", "abusefilter-revert", "abusefilter-view-private", "abusefilter-log-private", "abusefilter-hidden-log", "abusefilter-hide-log", "abusefilter-modify-global", "massmessage", "vipsscaler-test", "flow-hide", "flow-lock", "flow-delete", "flow-suppress", "flow-edit-post", "flow-create-board", "usermerge", "mwoauthproposeconsumer", "mwoauthupdateownconsumer", "mwoauthmanageconsumer", "mwoauthsuppress", "mwoauthviewsuppressed", "mwoauthviewprivate", "mwoauthmanagemygrants", "oathauth-enable", "oathauth-api-all", "checkuser", "checkuser-log", "autoreviewrestore", "stablesettings", "review", "unreviewedpages", "movestable", "validate", "templateeditor", "editeditorprotected", "editextendedsemiprotected", "extendedconfirmed", "viewdeletedfile", "transcode-reset", "transcode-status", "collectionsaveasuserpage", "collectionsaveascommunitypage", "translate", "translate-import", "translate-manage", "translate-messagereview", "translate-groupreview", "item-term", "property-term", "item-merge", "item-redirect", "property-create", "pagetranslation"].include?(value.to_s) && merge(aurights: value.to_s, replace: false)
      end

      # Which pieces of information to include:
      #
      # @param values [Array<String>] Allowed values: "blockinfo" (Adds the information about a current block on the user), "groups" (Lists groups that the user is in. This uses more server resources and may return fewer results than the limit), "implicitgroups" (Lists all the groups the user is automatically in), "rights" (Lists rights that the user has), "editcount" (Adds the edit count of the user), "registration" (Adds the timestamp of when the user registered if available (may be blank)), "centralids" (Adds the central IDs and attachment status for the user).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["blockinfo", "groups", "implicitgroups", "rights", "editcount", "registration", "centralids"].include?(value.to_s) && merge(auprop: value.to_s, replace: false)
      end

      # How many total user names to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(aulimit: value.to_s)
      end

      # Only list users who have made edits.
      #
      # @return [self]
      def witheditsonly()
        merge(auwitheditsonly: 'true')
      end

      # Only list users active in the last 30 days.
      #
      # @return [self]
      def activeusers()
        merge(auactiveusers: 'true')
      end

      # With auprop=centralids, also indicate whether the user is attached with the wiki identified by this ID.
      #
      # @param value [String]
      # @return [self]
      def attachedwiki(value)
        merge(auattachedwiki: value.to_s)
      end
    end
  end
end
