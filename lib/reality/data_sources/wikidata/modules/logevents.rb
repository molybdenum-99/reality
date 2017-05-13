# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Get events from logs.
    #
    # The "submodule" (MediaWiki API term) is included in action after setting some param, providing
    # additional tweaking for this param. Example (for {Reality::DataSources::Wikidata::Impl::Actions::Query} and
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
    module Logevents

      # Which properties to get:
      #
      # @param values [Array<String>] Allowed values: "ids" (Adds the ID of the log event), "title" (Adds the title of the page for the log event), "type" (Adds the type of log event), "user" (Adds the user responsible for the log event), "userid" (Adds the user ID who was responsible for the log event), "timestamp" (Adds the timestamp for the log event), "comment" (Adds the comment of the log event), "parsedcomment" (Adds the parsed comment of the log event), "details" (Lists additional details about the log event), "tags" (Lists tags for the log event).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["ids", "title", "type", "user", "userid", "timestamp", "comment", "parsedcomment", "details", "tags"].include?(value.to_s) && merge(leprop: value.to_s, replace: false)
      end

      # Filter log entries to only this type.
      #
      # @param value [String] One of "spamblacklist", "titleblacklist", "gblblock", "renameuser", "globalauth", "gblrights", "gblrename", "abusefilter", "massmessage", "notifytranslators", "thanks", "usermerge", "block", "protect", "rights", "delete", "upload", "move", "import", "patrol", "merge", "suppress", "tag", "managetags", "contentmodel", "timedmediahandler", "translationreview", "newusers", "pagelang", "pagetranslation".
      # @return [self]
      def type(value)
        _type(value) or fail ArgumentError, "Unknown value for type: #{value}"
      end

      # @private
      def _type(value)
        defined?(super) && super || ["spamblacklist", "titleblacklist", "gblblock", "renameuser", "globalauth", "gblrights", "gblrename", "abusefilter", "massmessage", "notifytranslators", "thanks", "usermerge", "block", "protect", "rights", "delete", "upload", "move", "import", "patrol", "merge", "suppress", "tag", "managetags", "contentmodel", "timedmediahandler", "translationreview", "newusers", "pagelang", "pagetranslation"].include?(value.to_s) && merge(letype: value.to_s)
      end

      # Filter log actions to only this action. Overrides letype. In the list of possible values, values with the asterisk wildcard such as action/* can have different strings after the slash (/).
      #
      # @param value [String] One of "gblblock/gblock", "gblblock/gblock2", "gblblock/gunblock", "gblblock/modify", "globalauth/delete", "globalauth/lock", "globalauth/unlock", "globalauth/hide", "globalauth/unhide", "globalauth/lockandhid", "globalauth/setstatus", "suppress/setstatus", "suppress/cadelete", "gblrights/usergroups", "gblrights/groupperms", "gblrights/groupprms2", "gblrights/groupprms3", "suppress/hide-afl", "suppress/unhide-afl", "usermerge/mergeuser", "usermerge/deleteuser", "spamblacklist/*", "titleblacklist/*", "gblblock/whitelist", "gblblock/dwhitelist", "renameuser/renameuser", "gblrights/grouprename", "gblrename/rename", "gblrename/promote", "gblrename/merge", "gblrights/newset", "gblrights/setrename", "gblrights/setnewtype", "gblrights/setchange", "gblrights/deleteset", "abusefilter/modify", "abusefilter/hit", "massmessage/*", "massmessage/send", "massmessage/failure", "massmessage/skipoptout", "massmessage/skipnouser", "massmessage/skipbadns", "notifytranslators/sent", "thanks/*", "delete/flow-restore-post", "suppress/flow-restore-post", "delete/flow-restore-topic", "suppress/flow-restore-topic", "lock/flow-restore-topic", "import/lqt-to-flow-topic", "block/block", "block/reblock", "block/unblock", "contentmodel/change", "contentmodel/new", "delete/delete", "delete/delete_redir", "delete/event", "delete/restore", "delete/revision", "import/interwiki", "import/upload", "managetags/activate", "managetags/create", "managetags/deactivate", "managetags/delete", "merge/merge", "move/move", "move/move_redir", "patrol/patrol", "patrol/autopatrol", "protect/modify", "protect/move_prot", "protect/protect", "protect/unprotect", "rights/autopromote", "rights/rights", "suppress/block", "suppress/delete", "suppress/event", "suppress/reblock", "suppress/revision", "tag/update", "upload/overwrite", "upload/revert", "upload/upload", "timedmediahandler/resettranscode", "translationreview/message", "translationreview/group", "delete/flow-delete-post", "delete/flow-delete-topic", "suppress/flow-suppress-post", "suppress/flow-suppress-topic", "lock/flow-lock-topic", "newusers/newusers", "newusers/create", "newusers/create2", "newusers/byemail", "newusers/autocreate", "pagelang/pagelang", "pagetranslation/mark", "pagetranslation/unmark", "pagetranslation/moveok", "pagetranslation/movenok", "pagetranslation/deletelok", "pagetranslation/deletefok", "pagetranslation/deletelnok", "pagetranslation/deletefnok", "pagetranslation/encourage", "pagetranslation/discourage", "pagetranslation/prioritylanguages", "pagetranslation/associate", "pagetranslation/dissociate".
      # @return [self]
      def action(value)
        _action(value) or fail ArgumentError, "Unknown value for action: #{value}"
      end

      # @private
      def _action(value)
        defined?(super) && super || ["gblblock/gblock", "gblblock/gblock2", "gblblock/gunblock", "gblblock/modify", "globalauth/delete", "globalauth/lock", "globalauth/unlock", "globalauth/hide", "globalauth/unhide", "globalauth/lockandhid", "globalauth/setstatus", "suppress/setstatus", "suppress/cadelete", "gblrights/usergroups", "gblrights/groupperms", "gblrights/groupprms2", "gblrights/groupprms3", "suppress/hide-afl", "suppress/unhide-afl", "usermerge/mergeuser", "usermerge/deleteuser", "spamblacklist/*", "titleblacklist/*", "gblblock/whitelist", "gblblock/dwhitelist", "renameuser/renameuser", "gblrights/grouprename", "gblrename/rename", "gblrename/promote", "gblrename/merge", "gblrights/newset", "gblrights/setrename", "gblrights/setnewtype", "gblrights/setchange", "gblrights/deleteset", "abusefilter/modify", "abusefilter/hit", "massmessage/*", "massmessage/send", "massmessage/failure", "massmessage/skipoptout", "massmessage/skipnouser", "massmessage/skipbadns", "notifytranslators/sent", "thanks/*", "delete/flow-restore-post", "suppress/flow-restore-post", "delete/flow-restore-topic", "suppress/flow-restore-topic", "lock/flow-restore-topic", "import/lqt-to-flow-topic", "block/block", "block/reblock", "block/unblock", "contentmodel/change", "contentmodel/new", "delete/delete", "delete/delete_redir", "delete/event", "delete/restore", "delete/revision", "import/interwiki", "import/upload", "managetags/activate", "managetags/create", "managetags/deactivate", "managetags/delete", "merge/merge", "move/move", "move/move_redir", "patrol/patrol", "patrol/autopatrol", "protect/modify", "protect/move_prot", "protect/protect", "protect/unprotect", "rights/autopromote", "rights/rights", "suppress/block", "suppress/delete", "suppress/event", "suppress/reblock", "suppress/revision", "tag/update", "upload/overwrite", "upload/revert", "upload/upload", "timedmediahandler/resettranscode", "translationreview/message", "translationreview/group", "delete/flow-delete-post", "delete/flow-delete-topic", "suppress/flow-suppress-post", "suppress/flow-suppress-topic", "lock/flow-lock-topic", "newusers/newusers", "newusers/create", "newusers/create2", "newusers/byemail", "newusers/autocreate", "pagelang/pagelang", "pagetranslation/mark", "pagetranslation/unmark", "pagetranslation/moveok", "pagetranslation/movenok", "pagetranslation/deletelok", "pagetranslation/deletefok", "pagetranslation/deletelnok", "pagetranslation/deletefnok", "pagetranslation/encourage", "pagetranslation/discourage", "pagetranslation/prioritylanguages", "pagetranslation/associate", "pagetranslation/dissociate"].include?(value.to_s) && merge(leaction: value.to_s)
      end

      # The timestamp to start enumerating from.
      #
      # @param value [Time]
      # @return [self]
      def start(value)
        merge(lestart: value.iso8601)
      end

      # The timestamp to end enumerating.
      #
      # @param value [Time]
      # @return [self]
      def end(value)
        merge(leend: value.iso8601)
      end

      # In which direction to enumerate:
      #
      # @param value [String] One of "newer" (List oldest first. Note: lestart has to be before leend), "older" (List newest first (default). Note: lestart has to be later than leend).
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["newer", "older"].include?(value.to_s) && merge(ledir: value.to_s)
      end

      # Filter entries to those made by the given user.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(leuser: value.to_s)
      end

      # Filter entries to those related to a page.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(letitle: value.to_s)
      end

      # Filter entries to those in the given namespace.
      #
      # @param value [String] One of "-2", "-1", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600".
      # @return [self]
      def namespace(value)
        _namespace(value) or fail ArgumentError, "Unknown value for namespace: #{value}"
      end

      # @private
      def _namespace(value)
        defined?(super) && super || ["-2", "-1", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600"].include?(value.to_s) && merge(lenamespace: value.to_s)
      end

      # Disabled due to miser mode.
      #
      # @param value [String]
      # @return [self]
      def prefix(value)
        merge(leprefix: value.to_s)
      end

      # Only list event entries tagged with this tag.
      #
      # @param value [String]
      # @return [self]
      def tag(value)
        merge(letag: value.to_s)
      end

      # How many total event entries to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(lelimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(lecontinue: value.to_s)
      end
    end
  end
end
