# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Enumerate all deleted files sequentially.
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
    module Filearchive

      # The image title to start enumerating from.
      #
      # @param value [String]
      # @return [self]
      def from(value)
        merge(fafrom: value.to_s)
      end

      # The image title to stop enumerating at.
      #
      # @param value [String]
      # @return [self]
      def to(value)
        merge(fato: value.to_s)
      end

      # Search for all image titles that begin with this value.
      #
      # @param value [String]
      # @return [self]
      def prefix(value)
        merge(faprefix: value.to_s)
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
        defined?(super) && super || ["ascending", "descending"].include?(value.to_s) && merge(fadir: value.to_s)
      end

      # SHA1 hash of image. Overrides fasha1base36.
      #
      # @param value [String]
      # @return [self]
      def sha1(value)
        merge(fasha1: value.to_s)
      end

      # SHA1 hash of image in base 36 (used in MediaWiki).
      #
      # @param value [String]
      # @return [self]
      def sha1base36(value)
        merge(fasha1base36: value.to_s)
      end

      # Which image information to get:
      #
      # @param values [Array<String>] Allowed values: "sha1" (Adds SHA-1 hash for the image), "timestamp" (Adds timestamp for the uploaded version), "user" (Adds user who uploaded the image version), "size" (Adds the size of the image in bytes and the height, width and page count (if applicable)), "dimensions" (Alias for size), "description" (Adds description of the image version), "parseddescription" (Parse the description of the version), "mime" (Adds MIME of the image), "mediatype" (Adds the media type of the image), "metadata" (Lists Exif metadata for the version of the image), "bitdepth" (Adds the bit depth of the version), "archivename" (Adds the filename of the archive version for non-latest versions).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["sha1", "timestamp", "user", "size", "dimensions", "description", "parseddescription", "mime", "mediatype", "metadata", "bitdepth", "archivename"].include?(value.to_s) && merge(faprop: value.to_s, replace: false)
      end

      # How many images to return in total.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(falimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(facontinue: value.to_s)
      end
    end
  end
end
