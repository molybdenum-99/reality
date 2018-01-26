# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Import a page from another wiki, or from an XML file.
    #
    # Usage:
    #
    # ```ruby
    # api.import.summary(value).perform # returns string with raw output
    # # or
    # api.import.summary(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Import < Reality::Describers::Wikidata::Impl::Actions::Post

      # Log entry import summary.
      #
      # @param value [String]
      # @return [self]
      def summary(value)
        merge(summary: value.to_s)
      end

      # Uploaded XML file.
      #
      # @param value [String]
      # @return [self]
      def xml(value)
        merge(xml: value.to_s)
      end

      # For interwiki imports: wiki to import from.
      #
      # @param value [String] One of "meta", "commons", "en", "de", "fr", "es".
      # @return [self]
      def interwikisource(value)
        _interwikisource(value) or fail ArgumentError, "Unknown value for interwikisource: #{value}"
      end

      # @private
      def _interwikisource(value)
        defined?(super) && super || ["meta", "commons", "en", "de", "fr", "es"].include?(value.to_s) && merge(interwikisource: value.to_s)
      end

      # For interwiki imports: page to import.
      #
      # @param value [String]
      # @return [self]
      def interwikipage(value)
        merge(interwikipage: value.to_s)
      end

      # For interwiki imports: import the full history, not just the current version.
      #
      # @return [self]
      def fullhistory()
        merge(fullhistory: 'true')
      end

      # For interwiki imports: import all included templates as well.
      #
      # @return [self]
      def templates()
        merge(templates: 'true')
      end

      # Import to this namespace. Cannot be used together with rootpage.
      #
      # @param value [String] One of "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600".
      # @return [self]
      def namespace(value)
        _namespace(value) or fail ArgumentError, "Unknown value for namespace: #{value}"
      end

      # @private
      def _namespace(value)
        defined?(super) && super || ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600"].include?(value.to_s) && merge(namespace: value.to_s)
      end

      # Import as subpage of this page. Cannot be used together with namespace.
      #
      # @param value [String]
      # @return [self]
      def rootpage(value)
        merge(rootpage: value.to_s)
      end

      # Change tags to apply to the entry in the import log and to the null revision on the imported pages.
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
