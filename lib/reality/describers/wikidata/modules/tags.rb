# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # List change tags.
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
    module Tags

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(tgcontinue: value.to_s)
      end

      # The maximum number of tags to list.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(tglimit: value.to_s)
      end

      # Which properties to get:
      #
      # @param values [Array<String>] Allowed values: "name" (Adds name of tag), "displayname" (Adds system message for the tag), "description" (Adds description of the tag), "hitcount" (Adds the number of revisions and log entries that have this tag), "defined" (Indicate whether the tag is defined), "source" (Gets the sources of the tag, which may include extension for extension-defined tags and manual for tags that may be applied manually by users), "active" (Whether the tag is still being applied).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["name", "displayname", "description", "hitcount", "defined", "source", "active"].include?(value.to_s) && merge(tgprop: value.to_s, replace: false)
      end
    end
  end
end
