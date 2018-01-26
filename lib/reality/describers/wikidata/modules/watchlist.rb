# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Get recent changes to pages in the current user's watchlist.
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
    module Watchlist

      # Include multiple revisions of the same page within given timeframe.
      #
      # @return [self]
      def allrev()
        merge(wlallrev: 'true')
      end

      # The timestamp to start enumerating from.
      #
      # @param value [Time]
      # @return [self]
      def start(value)
        merge(wlstart: value.iso8601)
      end

      # The timestamp to end enumerating.
      #
      # @param value [Time]
      # @return [self]
      def end(value)
        merge(wlend: value.iso8601)
      end

      # Filter changes to only the given namespaces.
      #
      # @param values [Array<String>] Allowed values: "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600".
      # @return [self]
      def namespace(*values)
        values.inject(self) { |res, val| res._namespace(val) or fail ArgumentError, "Unknown value for namespace: #{val}" }
      end

      # @private
      def _namespace(value)
        defined?(super) && super || ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600"].include?(value.to_s) && merge(wlnamespace: value.to_s, replace: false)
      end

      # Only list changes by this user.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(wluser: value.to_s)
      end

      # Don't list changes by this user.
      #
      # @param value [String]
      # @return [self]
      def excludeuser(value)
        merge(wlexcludeuser: value.to_s)
      end

      # In which direction to enumerate:
      #
      # @param value [String] One of "newer" (List oldest first. Note: wlstart has to be before wlend), "older" (List newest first (default). Note: wlstart has to be later than wlend).
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["newer", "older"].include?(value.to_s) && merge(wldir: value.to_s)
      end

      # How many total results to return per request.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(wllimit: value.to_s)
      end

      # Which additional properties to get:
      #
      # @param values [Array<String>] Allowed values: "ids" (Adds revision IDs and page IDs), "title" (Adds title of the page), "flags" (Adds flags for the edit), "user" (Adds the user who made the edit), "userid" (Adds user ID of whoever made the edit), "comment" (Adds comment of the edit), "parsedcomment" (Adds parsed comment of the edit), "timestamp" (Adds timestamp of the edit), "patrol" (Tags edits that are patrolled), "sizes" (Adds the old and new lengths of the page), "notificationtimestamp" (Adds timestamp of when the user was last notified about the edit), "loginfo" (Adds log information where appropriate), "oresscores" (Adds ORES scores for the edit).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["ids", "title", "flags", "user", "userid", "comment", "parsedcomment", "timestamp", "patrol", "sizes", "notificationtimestamp", "loginfo", "oresscores"].include?(value.to_s) && merge(wlprop: value.to_s, replace: false)
      end

      # Show only items that meet these criteria. For example, to see only minor edits done by logged-in users, set wlshow=minor|!anon.
      #
      # @param values [Array<String>] Allowed values: "minor", "!minor", "bot", "!bot", "anon", "!anon", "patrolled", "!patrolled", "unread", "!unread", "oresreview", "!oresreview".
      # @return [self]
      def show(*values)
        values.inject(self) { |res, val| res._show(val) or fail ArgumentError, "Unknown value for show: #{val}" }
      end

      # @private
      def _show(value)
        defined?(super) && super || ["minor", "!minor", "bot", "!bot", "anon", "!anon", "patrolled", "!patrolled", "unread", "!unread", "oresreview", "!oresreview"].include?(value.to_s) && merge(wlshow: value.to_s, replace: false)
      end

      # Which types of changes to show:
      #
      # @param values [Array<String>] Allowed values: "edit" (Regular page edits), "new" (Page creations), "log" (Log entries), "external" (External changes), "categorize" (Category membership changes).
      # @return [self]
      def type(*values)
        values.inject(self) { |res, val| res._type(val) or fail ArgumentError, "Unknown value for type: #{val}" }
      end

      # @private
      def _type(value)
        defined?(super) && super || ["edit", "new", "log", "external", "categorize"].include?(value.to_s) && merge(wltype: value.to_s, replace: false)
      end

      # Used along with wltoken to access a different user's watchlist.
      #
      # @param value [String]
      # @return [self]
      def owner(value)
        merge(wlowner: value.to_s)
      end

      # A security token (available in the user's preferences) to allow access to another user's watchlist.
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(wltoken: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(wlcontinue: value.to_s)
      end
    end
  end
end
