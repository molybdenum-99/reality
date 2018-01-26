# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Enumerate recent changes. _Generator module: for fetching pages corresponding to request._
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
    module GRecentchanges

      # The timestamp to start enumerating from.
      #
      # @param value [Time]
      # @return [self]
      def start(value)
        merge(grcstart: value.iso8601)
      end

      # The timestamp to end enumerating.
      #
      # @param value [Time]
      # @return [self]
      def end(value)
        merge(grcend: value.iso8601)
      end

      # In which direction to enumerate:
      #
      # @param value [String] One of "newer" (List oldest first. Note: rcstart has to be before rcend), "older" (List newest first (default). Note: rcstart has to be later than rcend).
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["newer", "older"].include?(value.to_s) && merge(grcdir: value.to_s)
      end

      # Filter changes to only these namespaces.
      #
      # @param values [Array<String>] Allowed values: "-2", "-1", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600".
      # @return [self]
      def namespace(*values)
        values.inject(self) { |res, val| res._namespace(val) or fail ArgumentError, "Unknown value for namespace: #{val}" }
      end

      # @private
      def _namespace(value)
        defined?(super) && super || ["-2", "-1", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600"].include?(value.to_s) && merge(grcnamespace: value.to_s, replace: false)
      end

      # Only list changes by this user.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(grcuser: value.to_s)
      end

      # Don't list changes by this user.
      #
      # @param value [String]
      # @return [self]
      def excludeuser(value)
        merge(grcexcludeuser: value.to_s)
      end

      # Only list changes tagged with this tag.
      #
      # @param value [String]
      # @return [self]
      def tag(value)
        merge(grctag: value.to_s)
      end

      # Use action=query&meta=tokens instead.
      #
      # @param values [Array<String>] Allowed values: "patrol".
      # @return [self]
      def token(*values)
        values.inject(self) { |res, val| res._token(val) or fail ArgumentError, "Unknown value for token: #{val}" }
      end

      # @private
      def _token(value)
        defined?(super) && super || ["patrol"].include?(value.to_s) && merge(grctoken: value.to_s, replace: false)
      end

      # Show only items that meet these criteria. For example, to see only minor edits done by logged-in users, set rcshow=minor|!anon.
      #
      # @param values [Array<String>] Allowed values: "minor", "!minor", "bot", "!bot", "anon", "!anon", "redirect", "!redirect", "patrolled", "!patrolled", "unpatrolled", "oresreview", "!oresreview".
      # @return [self]
      def show(*values)
        values.inject(self) { |res, val| res._show(val) or fail ArgumentError, "Unknown value for show: #{val}" }
      end

      # @private
      def _show(value)
        defined?(super) && super || ["minor", "!minor", "bot", "!bot", "anon", "!anon", "redirect", "!redirect", "patrolled", "!patrolled", "unpatrolled", "oresreview", "!oresreview"].include?(value.to_s) && merge(grcshow: value.to_s, replace: false)
      end

      # How many total changes to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(grclimit: value.to_s)
      end

      # Which types of changes to show.
      #
      # @param values [Array<String>] Allowed values: "edit", "new", "log", "external", "categorize".
      # @return [self]
      def type(*values)
        values.inject(self) { |res, val| res._type(val) or fail ArgumentError, "Unknown value for type: #{val}" }
      end

      # @private
      def _type(value)
        defined?(super) && super || ["edit", "new", "log", "external", "categorize"].include?(value.to_s) && merge(grctype: value.to_s, replace: false)
      end

      # Only list changes which are the latest revision.
      #
      # @return [self]
      def toponly()
        merge(grctoponly: 'true')
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(grccontinue: value.to_s)
      end

      # When being used as a generator, generate revision IDs rather than titles. Recent change entries without associated revision IDs (e.g. most log entries) will generate nothing.
      #
      # @return [self]
      def generaterevisions()
        merge(grcgeneraterevisions: 'true')
      end
    end
  end
end
