# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Returns file information and upload history.
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
    module Imageinfo

      # Which file information to get:
      #
      # @param values [Array<String>] Allowed values: "timestamp" (Adds timestamp for the uploaded version), "user" (Adds the user who uploaded each file version), "userid" (Add the ID of the user that uploaded each file version), "comment" (Comment on the version), "parsedcomment" (Parse the comment on the version), "canonicaltitle" (Adds the canonical title of the file), "url" (Gives URL to the file and the description page), "size" (Adds the size of the file in bytes and the height, width and page count (if applicable)), "dimensions" (Alias for size), "sha1" (Adds SHA-1 hash for the file), "mime" (Adds MIME type of the file), "thumbmime" (Adds MIME type of the image thumbnail (requires url and param iiurlwidth)), "mediatype" (Adds the media type of the file), "metadata" (Lists Exif metadata for the version of the file), "commonmetadata" (Lists file format generic metadata for the version of the file), "extmetadata" (Lists formatted metadata combined from multiple sources. Results are HTML formatted), "archivename" (Adds the filename of the archive version for non-latest versions), "bitdepth" (Adds the bit depth of the version), "uploadwarning" (Used by the Special:Upload page to get information about an existing file. Not intended for use outside MediaWiki core), "badfile" (Adds whether the file is on the MediaWiki:Bad image list).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["timestamp", "user", "userid", "comment", "parsedcomment", "canonicaltitle", "url", "size", "dimensions", "sha1", "mime", "thumbmime", "mediatype", "metadata", "commonmetadata", "extmetadata", "archivename", "bitdepth", "uploadwarning", "badfile"].include?(value.to_s) && merge(iiprop: value.to_s, replace: false)
      end

      # How many file revisions to return per file.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(iilimit: value.to_s)
      end

      # Timestamp to start listing from.
      #
      # @param value [Time]
      # @return [self]
      def start(value)
        merge(iistart: value.iso8601)
      end

      # Timestamp to stop listing at.
      #
      # @param value [Time]
      # @return [self]
      def end(value)
        merge(iiend: value.iso8601)
      end

      # If iiprop=url is set, a URL to an image scaled to this width will be returned. For performance reasons if this option is used, no more than 50 scaled images will be returned.
      #
      # @param value [Integer]
      # @return [self]
      def urlwidth(value)
        merge(iiurlwidth: value.to_s)
      end

      # Similar to iiurlwidth.
      #
      # @param value [Integer]
      # @return [self]
      def urlheight(value)
        merge(iiurlheight: value.to_s)
      end

      # Version of metadata to use. If latest is specified, use latest version. Defaults to 1 for backwards compatibility.
      #
      # @param value [String]
      # @return [self]
      def metadataversion(value)
        merge(iimetadataversion: value.to_s)
      end

      # What language to fetch extmetadata in. This affects both which translation to fetch, if multiple are available, as well as how things like numbers and various values are formatted.
      #
      # @param value [String]
      # @return [self]
      def extmetadatalanguage(value)
        merge(iiextmetadatalanguage: value.to_s)
      end

      # If translations for extmetadata property are available, fetch all of them.
      #
      # @return [self]
      def extmetadatamultilang()
        merge(iiextmetadatamultilang: 'true')
      end

      # If specified and non-empty, only these keys will be returned for iiprop=extmetadata.
      #
      # @param values [Array<String>]
      # @return [self]
      def extmetadatafilter(*values)
        values.inject(self) { |res, val| res._extmetadatafilter(val) }
      end

      # @private
      def _extmetadatafilter(value)
        merge(iiextmetadatafilter: value.to_s, replace: false)
      end

      # A handler specific parameter string. For example, PDFs might use page15-100px. iiurlwidth must be used and be consistent with iiurlparam.
      #
      # @param value [String]
      # @return [self]
      def urlparam(value)
        merge(iiurlparam: value.to_s)
      end

      # If badfilecontexttitleprop=badfile is set, this is the page title used when evaluating the MediaWiki:Bad image list
      #
      # @param value [String]
      # @return [self]
      def badfilecontexttitle(value)
        merge(iibadfilecontexttitle: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(iicontinue: value.to_s)
      end

      # Look only for files in the local repository.
      #
      # @return [self]
      def localonly()
        merge(iilocalonly: 'true')
      end
    end
  end
end
