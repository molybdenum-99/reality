# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Upload a file, or get the status of pending uploads.
    #
    # Usage:
    #
    # ```ruby
    # api.upload.filename(value).perform # returns string with raw output
    # # or
    # api.upload.filename(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Upload < Reality::Describers::Wikidata::Impl::Actions::Post

      # Target filename.
      #
      # @param value [String]
      # @return [self]
      def filename(value)
        merge(filename: value.to_s)
      end

      # Upload comment. Also used as the initial page text for new files if text is not specified.
      #
      # @param value [String]
      # @return [self]
      def comment(value)
        merge(comment: value.to_s)
      end

      # Change tags to apply to the upload log entry and file page revision.
      #
      # @param values [Array<String>] Allowed values: "InfoboxExport gadget", "WE-Framework gadget".
      # @return [self]
      def tags(*values)
        values.inject(self) { |res, val| res._tags(val) or fail ArgumentError, "Unknown value for tags: #{val}" }
      end

      # @private
      def _tags(value)
        defined?(super) && super || ["InfoboxExport gadget", "WE-Framework gadget"].include?(value.to_s) && merge(tags: value.to_s, replace: false)
      end

      # Initial page text for new files.
      #
      # @param value [String]
      # @return [self]
      def text(value)
        merge(text: value.to_s)
      end

      # Watch the page.
      #
      # @return [self]
      def watch()
        merge(watch: 'true')
      end

      # Unconditionally add or remove the page from the current user's watchlist, use preferences or do not change watch.
      #
      # @param value [String] One of "watch", "preferences", "nochange".
      # @return [self]
      def watchlist(value)
        _watchlist(value) or fail ArgumentError, "Unknown value for watchlist: #{value}"
      end

      # @private
      def _watchlist(value)
        defined?(super) && super || ["watch", "preferences", "nochange"].include?(value.to_s) && merge(watchlist: value.to_s)
      end

      # Ignore any warnings.
      #
      # @return [self]
      def ignorewarnings()
        merge(ignorewarnings: 'true')
      end

      # File contents.
      #
      # @param value [String]
      # @return [self]
      def file(value)
        merge(file: value.to_s)
      end

      # URL to fetch the file from.
      #
      # @param value [String]
      # @return [self]
      def url(value)
        merge(url: value.to_s)
      end

      # Key that identifies a previous upload that was stashed temporarily.
      #
      # @param value [String]
      # @return [self]
      def filekey(value)
        merge(filekey: value.to_s)
      end

      # Same as filekey, maintained for backward compatibility.
      #
      # @param value [String]
      # @return [self]
      def sessionkey(value)
        merge(sessionkey: value.to_s)
      end

      # If set, the server will stash the file temporarily instead of adding it to the repository.
      #
      # @return [self]
      def stash()
        merge(stash: 'true')
      end

      # Filesize of entire upload.
      #
      # @param value [Integer]
      # @return [self]
      def filesize(value)
        merge(filesize: value.to_s)
      end

      # Offset of chunk in bytes.
      #
      # @param value [Integer]
      # @return [self]
      def offset(value)
        merge(offset: value.to_s)
      end

      # Chunk contents.
      #
      # @param value [String]
      # @return [self]
      def chunk(value)
        merge(chunk: value.to_s)
      end

      # Make potentially large file operations asynchronous when possible.
      #
      # @return [self]
      def async()
        merge(async: 'true')
      end

      # Only fetch the upload status for the given file key.
      #
      # @return [self]
      def checkstatus()
        merge(checkstatus: 'true')
      end

      # A "csrf" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end
    end
  end
end
