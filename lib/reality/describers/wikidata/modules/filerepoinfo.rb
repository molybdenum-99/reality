# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Return meta information about image repositories configured on the wiki.
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
    module Filerepoinfo

      # Which repository properties to get (there may be more available on some wikis):
      #
      # @param values [Array<String>] Allowed values: "apiurl" (URL to the repository API - helpful for getting image info from the host), "name" (The key of the repository - used in e.g. $wgForeignFileRepos and imageinfo return values), "displayname" (The human-readable name of the repository wiki), "rooturl" (Root URL for image paths), "local" (Whether that repository is the local one or not).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["apiurl", "name", "displayname", "rooturl", "local"].include?(value.to_s) && merge(friprop: value.to_s, replace: false)
      end
    end
  end
end
