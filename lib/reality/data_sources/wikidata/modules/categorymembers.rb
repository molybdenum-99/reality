# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # List all pages in a given category.
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
    module Categorymembers

      # Which category to enumerate (required). Must include the Category: prefix. Cannot be used together with cmpageid.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(cmtitle: value.to_s)
      end

      # Page ID of the category to enumerate. Cannot be used together with cmtitle.
      #
      # @param value [Integer]
      # @return [self]
      def pageid(value)
        merge(cmpageid: value.to_s)
      end

      # Which pieces of information to include:
      #
      # @param values [Array<String>] Allowed values: "ids" (Adds the page ID), "title" (Adds the title and namespace ID of the page), "sortkey" (Adds the sortkey used for sorting in the category (hexadecimal string)), "sortkeyprefix" (Adds the sortkey prefix used for sorting in the category (human-readable part of the sortkey)), "type" (Adds the type that the page has been categorised as (page, subcat or file)), "timestamp" (Adds the timestamp of when the page was included).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["ids", "title", "sortkey", "sortkeyprefix", "type", "timestamp"].include?(value.to_s) && merge(cmprop: value.to_s, replace: false)
      end

      # Only include pages in these namespaces. Note that cmtype=subcat or cmtype=file may be used instead of cmnamespace=14 or 6.
      #
      # @param values [Array<String>] Allowed values: "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600".
      # @return [self]
      def namespace(*values)
        values.inject(self) { |res, val| res._namespace(val) or fail ArgumentError, "Unknown value for namespace: #{val}" }
      end

      # @private
      def _namespace(value)
        defined?(super) && super || ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600"].include?(value.to_s) && merge(cmnamespace: value.to_s, replace: false)
      end

      # Which type of category members to include. Ignored when cmsort=timestamp is set.
      #
      # @param values [Array<String>] Allowed values: "page", "subcat", "file".
      # @return [self]
      def type(*values)
        values.inject(self) { |res, val| res._type(val) or fail ArgumentError, "Unknown value for type: #{val}" }
      end

      # @private
      def _type(value)
        defined?(super) && super || ["page", "subcat", "file"].include?(value.to_s) && merge(cmtype: value.to_s, replace: false)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(cmcontinue: value.to_s)
      end

      # The maximum number of pages to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(cmlimit: value.to_s)
      end

      # Property to sort by.
      #
      # @param value [String] One of "sortkey", "timestamp".
      # @return [self]
      def sort(value)
        _sort(value) or fail ArgumentError, "Unknown value for sort: #{value}"
      end

      # @private
      def _sort(value)
        defined?(super) && super || ["sortkey", "timestamp"].include?(value.to_s) && merge(cmsort: value.to_s)
      end

      # In which direction to sort.
      #
      # @param value [String] One of "asc", "desc", "ascending", "descending", "newer", "older".
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["asc", "desc", "ascending", "descending", "newer", "older"].include?(value.to_s) && merge(cmdir: value.to_s)
      end

      # Timestamp to start listing from. Can only be used with cmsort=timestamp.
      #
      # @param value [Time]
      # @return [self]
      def start(value)
        merge(cmstart: value.iso8601)
      end

      # Timestamp to end listing at. Can only be used with cmsort=timestamp.
      #
      # @param value [Time]
      # @return [self]
      def end(value)
        merge(cmend: value.iso8601)
      end

      # Sortkey to start listing from, as returned by cmprop=sortkey. Can only be used with cmsort=sortkey.
      #
      # @param value [String]
      # @return [self]
      def starthexsortkey(value)
        merge(cmstarthexsortkey: value.to_s)
      end

      # Sortkey to end listing at, as returned by cmprop=sortkey. Can only be used with cmsort=sortkey.
      #
      # @param value [String]
      # @return [self]
      def endhexsortkey(value)
        merge(cmendhexsortkey: value.to_s)
      end

      # Sortkey prefix to start listing from. Can only be used with cmsort=sortkey. Overrides cmstarthexsortkey.
      #
      # @param value [String]
      # @return [self]
      def startsortkeyprefix(value)
        merge(cmstartsortkeyprefix: value.to_s)
      end

      # Sortkey prefix to end listing before (not at; if this value occurs it will not be included!). Can only be used with cmsort=sortkey. Overrides cmendhexsortkey.
      #
      # @param value [String]
      # @return [self]
      def endsortkeyprefix(value)
        merge(cmendsortkeyprefix: value.to_s)
      end

      # Use cmstarthexsortkey instead.
      #
      # @param value [String]
      # @return [self]
      def startsortkey(value)
        merge(cmstartsortkey: value.to_s)
      end

      # Use cmendhexsortkey instead.
      #
      # @param value [String]
      # @return [self]
      def endsortkey(value)
        merge(cmendsortkey: value.to_s)
      end
    end
  end
end
