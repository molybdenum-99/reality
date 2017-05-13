# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Enumerate all images sequentially.
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
    module Allimages

      # Property to sort by.
      #
      # @param value [String] One of "name", "timestamp".
      # @return [self]
      def sort(value)
        _sort(value) or fail ArgumentError, "Unknown value for sort: #{value}"
      end

      # @private
      def _sort(value)
        defined?(super) && super || ["name", "timestamp"].include?(value.to_s) && merge(aisort: value.to_s)
      end

      # The direction in which to list.
      #
      # @param value [String] One of "ascending", "descending", "newer", "older".
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["ascending", "descending", "newer", "older"].include?(value.to_s) && merge(aidir: value.to_s)
      end

      # The image title to start enumerating from. Can only be used with aisort=name.
      #
      # @param value [String]
      # @return [self]
      def from(value)
        merge(aifrom: value.to_s)
      end

      # The image title to stop enumerating at. Can only be used with aisort=name.
      #
      # @param value [String]
      # @return [self]
      def to(value)
        merge(aito: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(aicontinue: value.to_s)
      end

      # The timestamp to start enumerating from. Can only be used with aisort=timestamp.
      #
      # @param value [Time]
      # @return [self]
      def start(value)
        merge(aistart: value.iso8601)
      end

      # The timestamp to end enumerating. Can only be used with aisort=timestamp.
      #
      # @param value [Time]
      # @return [self]
      def end(value)
        merge(aiend: value.iso8601)
      end

      # Which file information to get:
      #
      # @param values [Array<String>] Allowed values: "timestamp" (Adds timestamp for the uploaded version), "user" (Adds the user who uploaded each file version), "userid" (Add the ID of the user that uploaded each file version), "comment" (Comment on the version), "parsedcomment" (Parse the comment on the version), "canonicaltitle" (Adds the canonical title of the file), "url" (Gives URL to the file and the description page), "size" (Adds the size of the file in bytes and the height, width and page count (if applicable)), "dimensions" (Alias for size), "sha1" (Adds SHA-1 hash for the file), "mime" (Adds MIME type of the file), "mediatype" (Adds the media type of the file), "metadata" (Lists Exif metadata for the version of the file), "commonmetadata" (Lists file format generic metadata for the version of the file), "extmetadata" (Lists formatted metadata combined from multiple sources. Results are HTML formatted), "bitdepth" (Adds the bit depth of the version), "badfile" (Adds whether the file is on the MediaWiki:Bad image list).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["timestamp", "user", "userid", "comment", "parsedcomment", "canonicaltitle", "url", "size", "dimensions", "sha1", "mime", "mediatype", "metadata", "commonmetadata", "extmetadata", "bitdepth", "badfile"].include?(value.to_s) && merge(aiprop: value.to_s, replace: false)
      end

      # Search for all image titles that begin with this value. Can only be used with aisort=name.
      #
      # @param value [String]
      # @return [self]
      def prefix(value)
        merge(aiprefix: value.to_s)
      end

      # Limit to images with at least this many bytes.
      #
      # @param value [Integer]
      # @return [self]
      def minsize(value)
        merge(aiminsize: value.to_s)
      end

      # Limit to images with at most this many bytes.
      #
      # @param value [Integer]
      # @return [self]
      def maxsize(value)
        merge(aimaxsize: value.to_s)
      end

      # SHA1 hash of image. Overrides aisha1base36.
      #
      # @param value [String]
      # @return [self]
      def sha1(value)
        merge(aisha1: value.to_s)
      end

      # SHA1 hash of image in base 36 (used in MediaWiki).
      #
      # @param value [String]
      # @return [self]
      def sha1base36(value)
        merge(aisha1base36: value.to_s)
      end

      # Only return files uploaded by this user. Can only be used with aisort=timestamp. Cannot be used together with aifilterbots.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(aiuser: value.to_s)
      end

      # How to filter files uploaded by bots. Can only be used with aisort=timestamp. Cannot be used together with aiuser.
      #
      # @param value [String] One of "all", "bots", "nobots".
      # @return [self]
      def filterbots(value)
        _filterbots(value) or fail ArgumentError, "Unknown value for filterbots: #{value}"
      end

      # @private
      def _filterbots(value)
        defined?(super) && super || ["all", "bots", "nobots"].include?(value.to_s) && merge(aifilterbots: value.to_s)
      end

      # Disabled due to miser mode.
      #
      # @param values [Array<String>]
      # @return [self]
      def mime(*values)
        values.inject(self) { |res, val| res._mime(val) }
      end

      # @private
      def _mime(value)
        merge(aimime: value.to_s, replace: false)
      end

      # How many images in total to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(ailimit: value.to_s)
      end
    end
  end
end
