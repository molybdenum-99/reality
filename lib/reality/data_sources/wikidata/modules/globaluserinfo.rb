# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Show information about a global user.
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
    module Globaluserinfo

      # User to get information about. Defaults to the current user.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(guiuser: value.to_s)
      end

      # Which properties to get:
      #
      # @param values [Array<String>] Allowed values: "groups" (Get a list of global groups this user belongs to), "rights" (Get a list of global rights this user has), "merged" (Get a list of merged accounts), "unattached" (Get a list of unattached accounts), "editcount" (Get the user's global edit count).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["groups", "rights", "merged", "unattached", "editcount"].include?(value.to_s) && merge(guiprop: value.to_s, replace: false)
      end
    end
  end
end
