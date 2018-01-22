# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Returns information about images on the page, such as thumbnail and presence of photos.
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
    module Pageimages

      # Which information to return:
      #
      # @param values [Array<String>] Allowed values: "thumbnail" (URL and dimensions of thumbnail image associated with page, if any), "original" (URL and original dimensions of image associated with page, if any), "name" (Image title).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["thumbnail", "original", "name"].include?(value.to_s) && merge(piprop: value.to_s, replace: false)
      end

      # Maximum thumbnail dimension.
      #
      # @param value [Integer]
      # @return [self]
      def thumbsize(value)
        merge(pithumbsize: value.to_s)
      end

      # Properties of how many pages to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(pilimit: value.to_s)
      end

      # Limit page images to a certain license type
      #
      # @param value [String] One of "free", "any".
      # @return [self]
      def license(value)
        _license(value) or fail ArgumentError, "Unknown value for license: #{value}"
      end

      # @private
      def _license(value)
        defined?(super) && super || ["free", "any"].include?(value.to_s) && merge(pilicense: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [Integer]
      # @return [self]
      def continue(value)
        merge(picontinue: value.to_s)
      end
    end
  end
end
