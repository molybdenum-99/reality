# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Returns all files contained on the given pages.
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
    module Images

      # How many files to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(imlimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(imcontinue: value.to_s)
      end

      # Only list these files. Useful for checking whether a certain page has a certain file.
      #
      # @param values [Array<String>]
      # @return [self]
      def images(*values)
        values.inject(self) { |res, val| res._images(val) }
      end

      # @private
      def _images(value)
        merge(imimages: value.to_s, replace: false)
      end

      # The direction in which to list.
      #
      # @param value [String] One of "ascending", "descending".
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["ascending", "descending"].include?(value.to_s) && merge(imdir: value.to_s)
      end
    end
  end
end
