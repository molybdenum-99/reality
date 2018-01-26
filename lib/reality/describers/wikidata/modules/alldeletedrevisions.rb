# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # List all deleted revisions by a user or in a namespace.
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
    module Alldeletedrevisions

      # Which properties to get for each revision:
      #
      # @param values [Array<String>] Allowed values: "ids" (The ID of the revision), "flags" (Revision flags (minor)), "timestamp" (The timestamp of the revision), "user" (User that made the revision), "userid" (User ID of the revision creator), "size" (Length (bytes) of the revision), "sha1" (SHA-1 (base 16) of the revision), "contentmodel" (Content model ID of the revision), "comment" (Comment by the user for the revision), "parsedcomment" (Parsed comment by the user for the revision), "content" (Text of the revision), "tags" (Tags for the revision), "parsetree" (The XML parse tree of revision content (requires content model wikitext)).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["ids", "flags", "timestamp", "user", "userid", "size", "sha1", "contentmodel", "comment", "parsedcomment", "content", "tags", "parsetree"].include?(value.to_s) && merge(adrprop: value.to_s, replace: false)
      end

      # Limit how many revisions will be returned.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(adrlimit: value.to_s)
      end

      # Expand templates in revision content (requires adrprop=content).
      #
      # @return [self]
      def expandtemplates()
        merge(adrexpandtemplates: 'true')
      end

      # Generate XML parse tree for revision content (requires adrprop=content; replaced by adrprop=parsetree).
      #
      # @return [self]
      def generatexml()
        merge(adrgeneratexml: 'true')
      end

      # Parse revision content (requires adrprop=content). For performance reasons, if this option is used, adrlimit is enforced to 1.
      #
      # @return [self]
      def parse()
        merge(adrparse: 'true')
      end

      # Only retrieve the content of this section number.
      #
      # @param value [String]
      # @return [self]
      def section(value)
        merge(adrsection: value.to_s)
      end

      # Revision ID to diff each revision to. Use prev, next and cur for the previous, next and current revision respectively.
      #
      # @param value [String]
      # @return [self]
      def diffto(value)
        merge(adrdiffto: value.to_s)
      end

      # Text to diff each revision to. Only diffs a limited number of revisions. Overrides adrdiffto. If adrsection is set, only that section will be diffed against this text.
      #
      # @param value [String]
      # @return [self]
      def difftotext(value)
        merge(adrdifftotext: value.to_s)
      end

      # Perform a pre-save transform on the text before diffing it. Only valid when used with adrdifftotext.
      #
      # @return [self]
      def difftotextpst()
        merge(adrdifftotextpst: 'true')
      end

      # Serialization format used for adrdifftotext and expected for output of content.
      #
      # @param value [String] One of "application/json", "text/x-wiki", "text/javascript", "text/css", "text/plain", "application/vnd.php.serialized".
      # @return [self]
      def contentformat(value)
        _contentformat(value) or fail ArgumentError, "Unknown value for contentformat: #{value}"
      end

      # @private
      def _contentformat(value)
        defined?(super) && super || ["application/json", "text/x-wiki", "text/javascript", "text/css", "text/plain", "application/vnd.php.serialized"].include?(value.to_s) && merge(adrcontentformat: value.to_s)
      end

      # Only list revisions by this user.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(adruser: value.to_s)
      end

      # Only list pages in this namespace.
      #
      # @param values [Array<String>] Allowed values: "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600".
      # @return [self]
      def namespace(*values)
        values.inject(self) { |res, val| res._namespace(val) or fail ArgumentError, "Unknown value for namespace: #{val}" }
      end

      # @private
      def _namespace(value)
        defined?(super) && super || ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600"].include?(value.to_s) && merge(adrnamespace: value.to_s, replace: false)
      end

      # The timestamp to start enumerating from.
      #
      # @param value [Time]
      # @return [self]
      def start(value)
        merge(adrstart: value.iso8601)
      end

      # The timestamp to stop enumerating at.
      #
      # @param value [Time]
      # @return [self]
      def end(value)
        merge(adrend: value.iso8601)
      end

      # In which direction to enumerate:
      #
      # @param value [String] One of "newer" (List oldest first. Note: adrstart has to be before adrend), "older" (List newest first (default). Note: adrstart has to be later than adrend).
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["newer", "older"].include?(value.to_s) && merge(adrdir: value.to_s)
      end

      # Start listing at this title.
      #
      # @param value [String]
      # @return [self]
      def from(value)
        merge(adrfrom: value.to_s)
      end

      # Stop listing at this title.
      #
      # @param value [String]
      # @return [self]
      def to(value)
        merge(adrto: value.to_s)
      end

      # Search for all page titles that begin with this value.
      #
      # @param value [String]
      # @return [self]
      def prefix(value)
        merge(adrprefix: value.to_s)
      end

      # Don't list revisions by this user.
      #
      # @param value [String]
      # @return [self]
      def excludeuser(value)
        merge(adrexcludeuser: value.to_s)
      end

      # Only list revisions tagged with this tag.
      #
      # @param value [String]
      # @return [self]
      def tag(value)
        merge(adrtag: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(adrcontinue: value.to_s)
      end

      # When being used as a generator, generate titles rather than revision IDs.
      #
      # @return [self]
      def generatetitles()
        merge(adrgeneratetitles: 'true')
      end
    end
  end
end
