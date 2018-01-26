# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Get deleted revision information. _Generator module: for fetching pages corresponding to request._
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
    module GDeletedrevisions

      # Limit how many revisions will be returned.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(gdrvlimit: value.to_s)
      end

      # Expand templates in revision content (requires drvprop=content).
      #
      # @return [self]
      def expandtemplates()
        merge(gdrvexpandtemplates: 'true')
      end

      # Generate XML parse tree for revision content (requires drvprop=content; replaced by drvprop=parsetree).
      #
      # @return [self]
      def generatexml()
        merge(gdrvgeneratexml: 'true')
      end

      # Parse revision content (requires drvprop=content). For performance reasons, if this option is used, drvlimit is enforced to 1.
      #
      # @return [self]
      def parse()
        merge(gdrvparse: 'true')
      end

      # Only retrieve the content of this section number.
      #
      # @param value [String]
      # @return [self]
      def section(value)
        merge(gdrvsection: value.to_s)
      end

      # Revision ID to diff each revision to. Use prev, next and cur for the previous, next and current revision respectively.
      #
      # @param value [String]
      # @return [self]
      def diffto(value)
        merge(gdrvdiffto: value.to_s)
      end

      # Text to diff each revision to. Only diffs a limited number of revisions. Overrides drvdiffto. If drvsection is set, only that section will be diffed against this text.
      #
      # @param value [String]
      # @return [self]
      def difftotext(value)
        merge(gdrvdifftotext: value.to_s)
      end

      # Perform a pre-save transform on the text before diffing it. Only valid when used with drvdifftotext.
      #
      # @return [self]
      def difftotextpst()
        merge(gdrvdifftotextpst: 'true')
      end

      # Serialization format used for drvdifftotext and expected for output of content.
      #
      # @param value [String] One of "application/json", "text/x-wiki", "text/javascript", "text/css", "text/plain", "application/vnd.php.serialized".
      # @return [self]
      def contentformat(value)
        _contentformat(value) or fail ArgumentError, "Unknown value for contentformat: #{value}"
      end

      # @private
      def _contentformat(value)
        defined?(super) && super || ["application/json", "text/x-wiki", "text/javascript", "text/css", "text/plain", "application/vnd.php.serialized"].include?(value.to_s) && merge(gdrvcontentformat: value.to_s)
      end

      # The timestamp to start enumerating from. Ignored when processing a list of revision IDs.
      #
      # @param value [Time]
      # @return [self]
      def start(value)
        merge(gdrvstart: value.iso8601)
      end

      # The timestamp to stop enumerating at. Ignored when processing a list of revision IDs.
      #
      # @param value [Time]
      # @return [self]
      def end(value)
        merge(gdrvend: value.iso8601)
      end

      # In which direction to enumerate:
      #
      # @param value [String] One of "newer" (List oldest first. Note: drvstart has to be before drvend), "older" (List newest first (default). Note: drvstart has to be later than drvend).
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["newer", "older"].include?(value.to_s) && merge(gdrvdir: value.to_s)
      end

      # Only list revisions tagged with this tag.
      #
      # @param value [String]
      # @return [self]
      def tag(value)
        merge(gdrvtag: value.to_s)
      end

      # Only list revisions by this user.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(gdrvuser: value.to_s)
      end

      # Don't list revisions by this user.
      #
      # @param value [String]
      # @return [self]
      def excludeuser(value)
        merge(gdrvexcludeuser: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(gdrvcontinue: value.to_s)
      end
    end
  end
end
