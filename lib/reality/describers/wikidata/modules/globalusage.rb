# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Returns global image usage for a certain image.
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
    module Globalusage

      # Which properties to return:
      #
      # @param values [Array<String>] Allowed values: "url" (Adds url), "pageid" (Adds page ID), "namespace" (Adds namespace ID).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["url", "pageid", "namespace"].include?(value.to_s) && merge(guprop: value.to_s, replace: false)
      end

      # How many links to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(gulimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(gucontinue: value.to_s)
      end

      # Filter local usage of the file.
      #
      # @return [self]
      def filterlocal()
        merge(gufilterlocal: 'true')
      end
    end
  end
end
