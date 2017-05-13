# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Check to see if two-factor authentication (OATH) is enabled for a user.
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
    module Oath

      # User to get information about. Defaults to the current user.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(oathuser: value.to_s)
      end
    end
  end
end
