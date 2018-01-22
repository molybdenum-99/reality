# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Get revision information. _Generator module: for fetching pages corresponding to request._
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
    module GRevisions

      # Limit how many revisions will be returned.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(grvlimit: value.to_s)
      end

      # Expand templates in revision content (requires rvprop=content).
      #
      # @return [self]
      def expandtemplates()
        merge(grvexpandtemplates: 'true')
      end

      # Generate XML parse tree for revision content (requires rvprop=content; replaced by rvprop=parsetree).
      #
      # @return [self]
      def generatexml()
        merge(grvgeneratexml: 'true')
      end

      # Parse revision content (requires rvprop=content). For performance reasons, if this option is used, rvlimit is enforced to 1.
      #
      # @return [self]
      def parse()
        merge(grvparse: 'true')
      end

      # Only retrieve the content of this section number.
      #
      # @param value [String]
      # @return [self]
      def section(value)
        merge(grvsection: value.to_s)
      end

      # Revision ID to diff each revision to. Use prev, next and cur for the previous, next and current revision respectively.
      #
      # @param value [String]
      # @return [self]
      def diffto(value)
        merge(grvdiffto: value.to_s)
      end

      # Text to diff each revision to. Only diffs a limited number of revisions. Overrides rvdiffto. If rvsection is set, only that section will be diffed against this text.
      #
      # @param value [String]
      # @return [self]
      def difftotext(value)
        merge(grvdifftotext: value.to_s)
      end

      # Perform a pre-save transform on the text before diffing it. Only valid when used with rvdifftotext.
      #
      # @return [self]
      def difftotextpst()
        merge(grvdifftotextpst: 'true')
      end

      # Serialization format used for rvdifftotext and expected for output of content.
      #
      # @param value [String] One of "application/json", "text/x-wiki", "text/javascript", "text/css", "text/plain", "application/vnd.php.serialized".
      # @return [self]
      def contentformat(value)
        _contentformat(value) or fail ArgumentError, "Unknown value for contentformat: #{value}"
      end

      # @private
      def _contentformat(value)
        defined?(super) && super || ["application/json", "text/x-wiki", "text/javascript", "text/css", "text/plain", "application/vnd.php.serialized"].include?(value.to_s) && merge(grvcontentformat: value.to_s)
      end

      # Start enumeration from this revision's timestamp. The revision must exist, but need not belong to this page.
      #
      # @param value [Integer]
      # @return [self]
      def startid(value)
        merge(grvstartid: value.to_s)
      end

      # Stop enumeration at this revision's timestamp. The revision must exist, but need not belong to this page.
      #
      # @param value [Integer]
      # @return [self]
      def endid(value)
        merge(grvendid: value.to_s)
      end

      # From which revision timestamp to start enumeration.
      #
      # @param value [Time]
      # @return [self]
      def start(value)
        merge(grvstart: value.iso8601)
      end

      # Enumerate up to this timestamp.
      #
      # @param value [Time]
      # @return [self]
      def end(value)
        merge(grvend: value.iso8601)
      end

      # In which direction to enumerate:
      #
      # @param value [String] One of "newer" (List oldest first. Note: rvstart has to be before rvend), "older" (List newest first (default). Note: rvstart has to be later than rvend).
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["newer", "older"].include?(value.to_s) && merge(grvdir: value.to_s)
      end

      # Only include revisions made by user.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(grvuser: value.to_s)
      end

      # Exclude revisions made by user.
      #
      # @param value [String]
      # @return [self]
      def excludeuser(value)
        merge(grvexcludeuser: value.to_s)
      end

      # Only list revisions tagged with this tag.
      #
      # @param value [String]
      # @return [self]
      def tag(value)
        merge(grvtag: value.to_s)
      end

      # Which tokens to obtain for each revision.
      #
      # @param values [Array<String>] Allowed values: "rollback".
      # @return [self]
      def token(*values)
        values.inject(self) { |res, val| res._token(val) or fail ArgumentError, "Unknown value for token: #{val}" }
      end

      # @private
      def _token(value)
        defined?(super) && super || ["rollback"].include?(value.to_s) && merge(grvtoken: value.to_s, replace: false)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(grvcontinue: value.to_s)
      end
    end
  end
end
