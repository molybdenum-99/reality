# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Get a list of files in the current user's upload stash.
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
    module Mystashedfiles

      # Which properties to fetch for the files.
      #
      # @param values [Array<String>] Allowed values: "size" (Fetch the file size and image dimensions), "type" (Fetch the file's MIME type and media type).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["size", "type"].include?(value.to_s) && merge(msfprop: value.to_s, replace: false)
      end

      # How many files to get.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(msflimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(msfcontinue: value.to_s)
      end
    end
  end
end
