# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Get information about what languages the user knows
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
    module Babel

      # User to get information about
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(babuser: value.to_s)
      end
    end
  end
end
