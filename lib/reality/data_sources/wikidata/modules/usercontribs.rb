# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Get all edits by a user.
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
    module Usercontribs

      # The maximum number of contributions to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(uclimit: value.to_s)
      end

      # The start timestamp to return from.
      #
      # @param value [Time]
      # @return [self]
      def start(value)
        merge(ucstart: value.iso8601)
      end

      # The end timestamp to return to.
      #
      # @param value [Time]
      # @return [self]
      def end(value)
        merge(ucend: value.iso8601)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(uccontinue: value.to_s)
      end

      # The users to retrieve contributions for. Cannot be used with ucuserids or ucuserprefix.
      #
      # @param values [Array<String>]
      # @return [self]
      def user(*values)
        values.inject(self) { |res, val| res._user(val) }
      end

      # @private
      def _user(value)
        merge(ucuser: value.to_s, replace: false)
      end

      # The user IDs to retrieve contributions for. Cannot be used with ucuser or ucuserprefix.
      #
      # @param values [Array<Integer>]
      # @return [self]
      def userids(*values)
        values.inject(self) { |res, val| res._userids(val) }
      end

      # @private
      def _userids(value)
        merge(ucuserids: value.to_s, replace: false)
      end

      # Retrieve contributions for all users whose names begin with this value. Cannot be used with ucuser or ucuserids.
      #
      # @param value [String]
      # @return [self]
      def userprefix(value)
        merge(ucuserprefix: value.to_s)
      end

      # In which direction to enumerate:
      #
      # @param value [String] One of "newer" (List oldest first. Note: ucstart has to be before ucend), "older" (List newest first (default). Note: ucstart has to be later than ucend).
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["newer", "older"].include?(value.to_s) && merge(ucdir: value.to_s)
      end

      # Only list contributions in these namespaces.
      #
      # @param values [Array<String>] Allowed values: "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600".
      # @return [self]
      def namespace(*values)
        values.inject(self) { |res, val| res._namespace(val) or fail ArgumentError, "Unknown value for namespace: #{val}" }
      end

      # @private
      def _namespace(value)
        defined?(super) && super || ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600"].include?(value.to_s) && merge(ucnamespace: value.to_s, replace: false)
      end

      # Include additional pieces of information:
      #
      # @param values [Array<String>] Allowed values: "ids" (Adds the page ID and revision ID), "title" (Adds the title and namespace ID of the page), "timestamp" (Adds the timestamp of the edit), "comment" (Adds the comment of the edit), "parsedcomment" (Adds the parsed comment of the edit), "size" (Adds the new size of the edit), "sizediff" (Adds the size delta of the edit against its parent), "flags" (Adds flags of the edit), "patrolled" (Tags patrolled edits), "tags" (Lists tags for the edit), "oresscores" (Adds ORES scores for the edit).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["ids", "title", "timestamp", "comment", "parsedcomment", "size", "sizediff", "flags", "patrolled", "tags", "oresscores"].include?(value.to_s) && merge(ucprop: value.to_s, replace: false)
      end

      # Show only items that meet these criteria, e.g. non minor edits only: ucshow=!minor.
      #
      # @param values [Array<String>] Allowed values: "minor", "!minor", "patrolled", "!patrolled", "top", "!top", "new", "!new", "oresreview", "!oresreview".
      # @return [self]
      def show(*values)
        values.inject(self) { |res, val| res._show(val) or fail ArgumentError, "Unknown value for show: #{val}" }
      end

      # @private
      def _show(value)
        defined?(super) && super || ["minor", "!minor", "patrolled", "!patrolled", "top", "!top", "new", "!new", "oresreview", "!oresreview"].include?(value.to_s) && merge(ucshow: value.to_s, replace: false)
      end

      # Only list revisions tagged with this tag.
      #
      # @param value [String]
      # @return [self]
      def tag(value)
        merge(uctag: value.to_s)
      end

      # Only list changes which are the latest revision.
      #
      # @return [self]
      def toponly()
        merge(uctoponly: 'true')
      end
    end
  end
end
