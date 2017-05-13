# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Get basic page information.
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
    module Info

      # Which additional properties to get:
      #
      # @param values [Array<String>] Allowed values: "protection" (List the protection level of each page), "talkid" (The page ID of the talk page for each non-talk page), "watched" (List the watched status of each page), "watchers" (The number of watchers, if allowed), "visitingwatchers" (The number of watchers of each page who have visited recent edits to that page, if allowed), "notificationtimestamp" (The watchlist notification timestamp of each page), "subjectid" (The page ID of the parent page for each talk page), "url" (Gives a full URL, an edit URL, and the canonical URL for each page), "readable" (Whether the user can read this page), "preload" (Gives the text returned by EditFormPreloadText), "displaytitle" (Gives the manner in which the page title is actually displayed).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["protection", "talkid", "watched", "watchers", "visitingwatchers", "notificationtimestamp", "subjectid", "url", "readable", "preload", "displaytitle"].include?(value.to_s) && merge(inprop: value.to_s, replace: false)
      end

      # Test whether the current user can perform certain actions on the page.
      #
      # @param values [Array<String>]
      # @return [self]
      def testactions(*values)
        values.inject(self) { |res, val| res._testactions(val) }
      end

      # @private
      def _testactions(value)
        merge(intestactions: value.to_s, replace: false)
      end

      # Use action=query&meta=tokens instead.
      #
      # @param values [Array<String>] Allowed values: "edit", "delete", "protect", "move", "block", "unblock", "email", "import", "watch".
      # @return [self]
      def token(*values)
        values.inject(self) { |res, val| res._token(val) or fail ArgumentError, "Unknown value for token: #{val}" }
      end

      # @private
      def _token(value)
        defined?(super) && super || ["edit", "delete", "protect", "move", "block", "unblock", "email", "import", "watch"].include?(value.to_s) && merge(intoken: value.to_s, replace: false)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(incontinue: value.to_s)
      end
    end
  end
end
