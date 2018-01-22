# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # List all revisions. _Generator module: for fetching pages corresponding to request._
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
    module GAllrevisions

      # Limit how many revisions will be returned.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(garvlimit: value.to_s)
      end

      # Expand templates in revision content (requires arvprop=content).
      #
      # @return [self]
      def expandtemplates()
        merge(garvexpandtemplates: 'true')
      end

      # Generate XML parse tree for revision content (requires arvprop=content; replaced by arvprop=parsetree).
      #
      # @return [self]
      def generatexml()
        merge(garvgeneratexml: 'true')
      end

      # Parse revision content (requires arvprop=content). For performance reasons, if this option is used, arvlimit is enforced to 1.
      #
      # @return [self]
      def parse()
        merge(garvparse: 'true')
      end

      # Only retrieve the content of this section number.
      #
      # @param value [String]
      # @return [self]
      def section(value)
        merge(garvsection: value.to_s)
      end

      # Revision ID to diff each revision to. Use prev, next and cur for the previous, next and current revision respectively.
      #
      # @param value [String]
      # @return [self]
      def diffto(value)
        merge(garvdiffto: value.to_s)
      end

      # Text to diff each revision to. Only diffs a limited number of revisions. Overrides arvdiffto. If arvsection is set, only that section will be diffed against this text.
      #
      # @param value [String]
      # @return [self]
      def difftotext(value)
        merge(garvdifftotext: value.to_s)
      end

      # Perform a pre-save transform on the text before diffing it. Only valid when used with arvdifftotext.
      #
      # @return [self]
      def difftotextpst()
        merge(garvdifftotextpst: 'true')
      end

      # Serialization format used for arvdifftotext and expected for output of content.
      #
      # @param value [String] One of "application/json", "text/x-wiki", "text/javascript", "text/css", "text/plain", "application/vnd.php.serialized".
      # @return [self]
      def contentformat(value)
        _contentformat(value) or fail ArgumentError, "Unknown value for contentformat: #{value}"
      end

      # @private
      def _contentformat(value)
        defined?(super) && super || ["application/json", "text/x-wiki", "text/javascript", "text/css", "text/plain", "application/vnd.php.serialized"].include?(value.to_s) && merge(garvcontentformat: value.to_s)
      end

      # Only list revisions by this user.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(garvuser: value.to_s)
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
        defined?(super) && super || ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600"].include?(value.to_s) && merge(garvnamespace: value.to_s, replace: false)
      end

      # The timestamp to start enumerating from.
      #
      # @param value [Time]
      # @return [self]
      def start(value)
        merge(garvstart: value.iso8601)
      end

      # The timestamp to stop enumerating at.
      #
      # @param value [Time]
      # @return [self]
      def end(value)
        merge(garvend: value.iso8601)
      end

      # In which direction to enumerate:
      #
      # @param value [String] One of "newer" (List oldest first. Note: arvstart has to be before arvend), "older" (List newest first (default). Note: arvstart has to be later than arvend).
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["newer", "older"].include?(value.to_s) && merge(garvdir: value.to_s)
      end

      # Don't list revisions by this user.
      #
      # @param value [String]
      # @return [self]
      def excludeuser(value)
        merge(garvexcludeuser: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(garvcontinue: value.to_s)
      end

      # When being used as a generator, generate titles rather than revision IDs.
      #
      # @return [self]
      def generatetitles()
        merge(garvgeneratetitles: 'true')
      end
    end
  end
end
