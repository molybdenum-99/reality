# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Extends imageinfo to include video source (derivatives) information
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
    module Videoinfo

      # Which file information to get:
      #
      # @param values [Array<String>] Allowed values: "timestamp" (Adds timestamp for the uploaded version), "user" (Adds the user who uploaded each file version), "userid" (Add the ID of the user that uploaded each file version), "comment" (Comment on the version), "parsedcomment" (Parse the comment on the version), "canonicaltitle" (Adds the canonical title of the file), "url" (Gives URL to the file and the description page), "size" (Adds the size of the file in bytes and the height, width and page count (if applicable)), "dimensions" (Alias for size), "sha1" (Adds SHA-1 hash for the file), "mime" (Adds MIME type of the file), "thumbmime" (Adds MIME type of the image thumbnail (requires url and param viurlwidth)), "mediatype" (Adds the media type of the file), "metadata" (Lists Exif metadata for the version of the file), "commonmetadata" (Lists file format generic metadata for the version of the file), "extmetadata" (Lists formatted metadata combined from multiple sources. Results are HTML formatted), "archivename" (Adds the filename of the archive version for non-latest versions), "bitdepth" (Adds the bit depth of the version), "uploadwarning" (Used by the Special:Upload page to get information about an existing file. Not intended for use outside MediaWiki core), "badfile" (Adds whether the file is on the MediaWiki:Bad image list), "derivatives" (Adds an array of the different format and quality versions of an audio or video file that are available), "timedtext" (Adds an array of the subtitles, captions and descriptions of an audio or video file that are available).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["timestamp", "user", "userid", "comment", "parsedcomment", "canonicaltitle", "url", "size", "dimensions", "sha1", "mime", "thumbmime", "mediatype", "metadata", "commonmetadata", "extmetadata", "archivename", "bitdepth", "uploadwarning", "badfile", "derivatives", "timedtext"].include?(value.to_s) && merge(viprop: value.to_s, replace: false)
      end

      # How many file revisions to return per file.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(vilimit: value.to_s)
      end

      # Timestamp to start listing from.
      #
      # @param value [Time]
      # @return [self]
      def start(value)
        merge(vistart: value.iso8601)
      end

      # Timestamp to stop listing at.
      #
      # @param value [Time]
      # @return [self]
      def end(value)
        merge(viend: value.iso8601)
      end

      # If viprop=url is set, a URL to an image scaled to this width will be returned. For performance reasons if this option is used, no more than 50 scaled images will be returned.
      #
      # @param value [Integer]
      # @return [self]
      def urlwidth(value)
        merge(viurlwidth: value.to_s)
      end

      # Similar to viurlwidth.
      #
      # @param value [Integer]
      # @return [self]
      def urlheight(value)
        merge(viurlheight: value.to_s)
      end

      # Version of metadata to use. If latest is specified, use latest version. Defaults to 1 for backwards compatibility.
      #
      # @param value [String]
      # @return [self]
      def metadataversion(value)
        merge(vimetadataversion: value.to_s)
      end

      # What language to fetch extmetadata in. This affects both which translation to fetch, if multiple are available, as well as how things like numbers and various values are formatted.
      #
      # @param value [String]
      # @return [self]
      def extmetadatalanguage(value)
        merge(viextmetadatalanguage: value.to_s)
      end

      # If translations for extmetadata property are available, fetch all of them.
      #
      # @return [self]
      def extmetadatamultilang()
        merge(viextmetadatamultilang: 'true')
      end

      # If specified and non-empty, only these keys will be returned for viprop=extmetadata.
      #
      # @param values [Array<String>]
      # @return [self]
      def extmetadatafilter(*values)
        values.inject(self) { |res, val| res._extmetadatafilter(val) }
      end

      # @private
      def _extmetadatafilter(value)
        merge(viextmetadatafilter: value.to_s, replace: false)
      end

      # A handler specific parameter string. For example, PDFs might use page15-100px. viurlwidth must be used and be consistent with viurlparam.
      #
      # @param value [String]
      # @return [self]
      def urlparam(value)
        merge(viurlparam: value.to_s)
      end

      # If badfilecontexttitleprop=badfile is set, this is the page title used when evaluating the MediaWiki:Bad image list
      #
      # @param value [String]
      # @return [self]
      def badfilecontexttitle(value)
        merge(vibadfilecontexttitle: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(vicontinue: value.to_s)
      end

      # Look only for files in the local repository.
      #
      # @param value [String]
      # @return [self]
      def localonly(value)
        merge(vilocalonly: value.to_s)
      end
    end
  end
end
