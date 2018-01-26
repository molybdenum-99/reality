# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Returns data needed for mobile views.
    #
    # Usage:
    #
    # ```ruby
    # api.mobileview.page(value).perform # returns string with raw output
    # # or
    # api.mobileview.page(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Mobileview < Reality::Describers::Wikidata::Impl::Actions::Get

      # Title of page to process.
      #
      # @param value [String]
      # @return [self]
      def page(value)
        merge(page: value.to_s)
      end

      # Whether redirects should be followed.
      #
      # @param value [String] One of "yes", "no".
      # @return [self]
      def redirect(value)
        _redirect(value) or fail ArgumentError, "Unknown value for redirect: #{value}"
      end

      # @private
      def _redirect(value)
        defined?(super) && super || ["yes", "no"].include?(value.to_s) && merge(redirect: value.to_s)
      end

      # Pipe-separated list of section numbers for which to return text. "all" can be used to return for all. Ranges in format "1-4" mean get sections 1,2,3,4. Ranges without second number, e.g. "1-" means get all until the end. "references" can be used to specify that all sections containing references should be returned.
      #
      # @param value [String]
      # @return [self]
      def sections(value)
        merge(sections: value.to_s)
      end

      # Which information to get:
      #
      # @param values [Array<String>] Allowed values: "text" (HTML of selected sections), "sections" (Information about all sections on the page), "normalizedtitle" (Normalized page title), "lastmodified" (ISO 8601 timestamp for when the page was last modified, e.g. "2014-04-13T22:42:14Z"), "lastmodifiedby" (Information about the user who modified the page last), "revision" (Return the current revision ID of the page), "protection" (Information about protection level), "editable" (Whether the current user can edit this page. This includes all factors for logged-in users but not blocked status for anons), "languagecount" (Number of languages that the page is available in), "hasvariants" (Whether or not the page is available in other language variants), "displaytitle" (The rendered title of the page, with {{DISPLAYTITLE}} and such applied), "pageprops" (Page properties).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["text", "sections", "normalizedtitle", "lastmodified", "lastmodifiedby", "revision", "protection", "editable", "languagecount", "hasvariants", "displaytitle", "pageprops"].include?(value.to_s) && merge(prop: value.to_s, replace: false)
      end

      # What information about sections to get.
      #
      # @param values [Array<String>] Allowed values: "toclevel", "level", "line", "number", "index", "fromtitle", "anchor".
      # @return [self]
      def sectionprop(*values)
        values.inject(self) { |res, val| res._sectionprop(val) or fail ArgumentError, "Unknown value for sectionprop: #{val}" }
      end

      # @private
      def _sectionprop(value)
        defined?(super) && super || ["toclevel", "level", "line", "number", "index", "fromtitle", "anchor"].include?(value.to_s) && merge(sectionprop: value.to_s, replace: false)
      end

      # What page properties to return, a pipe ("|") separated list or "*" for all properties.
      #
      # @param value [String]
      # @return [self]
      def pageprops(value)
        merge(pageprops: value.to_s)
      end

      # Convert content into this language variant.
      #
      # @param value [String]
      # @return [self]
      def variant(value)
        merge(variant: value.to_s)
      end

      # Return HTML without images.
      #
      # @return [self]
      def noimages()
        merge(noimages: 'true')
      end

      # Don't include headings in output.
      #
      # @return [self]
      def noheadings()
        merge(noheadings: 'true')
      end

      # Don't transform HTML into mobile-specific version.
      #
      # @return [self]
      def notransform()
        merge(notransform: 'true')
      end

      # Return only requested sections even with prop=sections.
      #
      # @return [self]
      def onlyrequestedsections()
        merge(onlyrequestedsections: 'true')
      end

      # Pretend all text result is one string, and return the substring starting at this point.
      #
      # @param value [Integer]
      # @return [self]
      def offset(value)
        merge(offset: value.to_s)
      end

      # Pretend all text result is one string, and limit result to this length.
      #
      # @param value [Integer]
      # @return [self]
      def maxlen(value)
        merge(maxlen: value.to_s)
      end

      # Request a specific revision.
      #
      # @param value [Integer]
      # @return [self]
      def revision(value)
        merge(revision: value.to_s)
      end

      # Maximum thumbnail height.
      #
      # @param value [Integer]
      # @return [self]
      def thumbheight(value)
        merge(thumbheight: value.to_s)
      end

      # Maximum thumbnail width.
      #
      # @param value [Integer]
      # @return [self]
      def thumbwidth(value)
        merge(thumbwidth: value.to_s)
      end

      # Maximum thumbnail dimensions.
      #
      # @param value [Integer]
      # @return [self]
      def thumbsize(value)
        merge(thumbsize: value.to_s)
      end
    end
  end
end
