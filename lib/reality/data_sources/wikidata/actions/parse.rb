# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Parses content and returns parser output.
    #
    # Usage:
    #
    # ```ruby
    # api.parse.title(value).perform # returns string with raw output
    # # or
    # api.parse.title(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Parse < Reality::DataSources::Wikidata::Impl::Actions::Get

      # Title of page the text belongs to. If omitted, contentmodel must be specified, and API will be used as the title.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(title: value.to_s)
      end

      # Text to parse. Use title or contentmodel to control the content model.
      #
      # @param value [String]
      # @return [self]
      def text(value)
        merge(text: value.to_s)
      end

      # Summary to parse.
      #
      # @param value [String]
      # @return [self]
      def summary(value)
        merge(summary: value.to_s)
      end

      # Parse the content of this page. Cannot be used together with text and title.
      #
      # @param value [String]
      # @return [self]
      def page(value)
        merge(page: value.to_s)
      end

      # Parse the content of this page. Overrides page.
      #
      # @param value [Integer]
      # @return [self]
      def pageid(value)
        merge(pageid: value.to_s)
      end

      # If page or pageid is set to a redirect, resolve it.
      #
      # @return [self]
      def redirects()
        merge(redirects: 'true')
      end

      # Parse the content of this revision. Overrides page and pageid.
      #
      # @param value [Integer]
      # @return [self]
      def oldid(value)
        merge(oldid: value.to_s)
      end

      # Which pieces of information to get:
      #
      # @param values [Array<String>] Allowed values: "text" (Gives the parsed text of the wikitext), "langlinks" (Gives the language links in the parsed wikitext), "categories" (Gives the categories in the parsed wikitext), "categorieshtml" (Gives the HTML version of the categories), "links" (Gives the internal links in the parsed wikitext), "templates" (Gives the templates in the parsed wikitext), "images" (Gives the images in the parsed wikitext), "externallinks" (Gives the external links in the parsed wikitext), "sections" (Gives the sections in the parsed wikitext), "revid" (Adds the revision ID of the parsed page), "displaytitle" (Adds the title of the parsed wikitext), "headitems" (Deprecated. Gives items to put in the <head> of the page), "headhtml" (Gives parsed <head> of the page), "modules" (Gives the ResourceLoader modules used on the page. To load, use mw.loader.using(). Either jsconfigvars or encodedjsconfigvars must be requested jointly with modules), "jsconfigvars" (Gives the JavaScript configuration variables specific to the page. To apply, use mw.config.set()), "encodedjsconfigvars" (Gives the JavaScript configuration variables specific to the page as a JSON string), "indicators" (Gives the HTML of page status indicators used on the page), "iwlinks" (Gives interwiki links in the parsed wikitext), "wikitext" (Gives the original wikitext that was parsed), "properties" (Gives various properties defined in the parsed wikitext), "limitreportdata" (Gives the limit report in a structured way. Gives no data, when disablelimitreport is set), "limitreporthtml" (Gives the HTML version of the limit report. Gives no data, when disablelimitreport is set), "parsetree" (The XML parse tree of revision content (requires content model wikitext)), "parsewarnings" (Gives the warnings that occurred while parsing content).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["text", "langlinks", "categories", "categorieshtml", "links", "templates", "images", "externallinks", "sections", "revid", "displaytitle", "headitems", "headhtml", "modules", "jsconfigvars", "encodedjsconfigvars", "indicators", "iwlinks", "wikitext", "properties", "limitreportdata", "limitreporthtml", "parsetree", "parsewarnings"].include?(value.to_s) && merge(prop: value.to_s, replace: false)
      end

      # CSS class to use to wrap the parser output.
      #
      # @param value [String]
      # @return [self]
      def wrapoutputclass(value)
        merge(wrapoutputclass: value.to_s)
      end

      # Do a pre-save transform on the input before parsing it. Only valid when used with text.
      #
      # @return [self]
      def pst()
        merge(pst: 'true')
      end

      # Do a pre-save transform (PST) on the input, but don't parse it. Returns the same wikitext, after a PST has been applied. Only valid when used with text.
      #
      # @return [self]
      def onlypst()
        merge(onlypst: 'true')
      end

      # Includes language links supplied by extensions (for use with prop=langlinks).
      #
      # @return [self]
      def effectivelanglinks()
        merge(effectivelanglinks: 'true')
      end

      # Only parse the content of this section number.
      #
      # @param value [String]
      # @return [self]
      def section(value)
        merge(section: value.to_s)
      end

      # New section title when section is new.
      #
      # @param value [String]
      # @return [self]
      def sectiontitle(value)
        merge(sectiontitle: value.to_s)
      end

      # Use disablelimitreport instead.
      #
      # @return [self]
      def disablepp()
        merge(disablepp: 'true')
      end

      # Omit the limit report ("NewPP limit report") from the parser output.
      #
      # @return [self]
      def disablelimitreport()
        merge(disablelimitreport: 'true')
      end

      # Omit edit section links from the parser output.
      #
      # @return [self]
      def disableeditsection()
        merge(disableeditsection: 'true')
      end

      # Do not run HTML cleanup (e.g. tidy) on the parser output.
      #
      # @return [self]
      def disabletidy()
        merge(disabletidy: 'true')
      end

      # Generate XML parse tree (requires content model wikitext; replaced by prop=parsetree).
      #
      # @return [self]
      def generatexml()
        merge(generatexml: 'true')
      end

      # Parse in preview mode.
      #
      # @return [self]
      def preview()
        merge(preview: 'true')
      end

      # Parse in section preview mode (enables preview mode too).
      #
      # @return [self]
      def sectionpreview()
        merge(sectionpreview: 'true')
      end

      # Omit table of contents in output.
      #
      # @return [self]
      def disabletoc()
        merge(disabletoc: 'true')
      end

      # Content serialization format used for the input text. Only valid when used with text.
      #
      # @param value [String] One of "application/json", "text/x-wiki", "text/javascript", "text/css", "text/plain", "application/vnd.php.serialized".
      # @return [self]
      def contentformat(value)
        _contentformat(value) or fail ArgumentError, "Unknown value for contentformat: #{value}"
      end

      # @private
      def _contentformat(value)
        defined?(super) && super || ["application/json", "text/x-wiki", "text/javascript", "text/css", "text/plain", "application/vnd.php.serialized"].include?(value.to_s) && merge(contentformat: value.to_s)
      end

      # Content model of the input text. If omitted, title must be specified, and default will be the model of the specified title. Only valid when used with text.
      #
      # @param value [String] One of "GadgetDefinition", "SecurePoll", "MassMessageListContent", "flow-board", "JsonSchema", "wikitext", "javascript", "json", "css", "text", "Scribunto", "wikibase-item", "wikibase-property".
      # @return [self]
      def contentmodel(value)
        _contentmodel(value) or fail ArgumentError, "Unknown value for contentmodel: #{value}"
      end

      # @private
      def _contentmodel(value)
        defined?(super) && super || ["GadgetDefinition", "SecurePoll", "MassMessageListContent", "flow-board", "JsonSchema", "wikitext", "javascript", "json", "css", "text", "Scribunto", "wikibase-item", "wikibase-property"].include?(value.to_s) && merge(contentmodel: value.to_s)
      end

      # Return parse output in a format suitable for mobile devices.
      #
      # @return [self]
      def mobileformat()
        merge(mobileformat: 'true')
      end

      # Disable images in mobile output.
      #
      # @return [self]
      def noimages()
        merge(noimages: 'true')
      end

      # Apply mobile main page transformations.
      #
      # @return [self]
      def mainpage()
        merge(mainpage: 'true')
      end

      # Template sandbox prefix, as with Special:TemplateSandbox.
      #
      # @param values [Array<String>]
      # @return [self]
      def templatesandboxprefix(*values)
        values.inject(self) { |res, val| res._templatesandboxprefix(val) }
      end

      # @private
      def _templatesandboxprefix(value)
        merge(templatesandboxprefix: value.to_s, replace: false)
      end

      # Parse the page using templatesandboxtext in place of the contents of the page named here.
      #
      # @param value [String]
      # @return [self]
      def templatesandboxtitle(value)
        merge(templatesandboxtitle: value.to_s)
      end

      # Parse the page using this page content in place of the page named by templatesandboxtitle.
      #
      # @param value [String]
      # @return [self]
      def templatesandboxtext(value)
        merge(templatesandboxtext: value.to_s)
      end

      # Content model of templatesandboxtext.
      #
      # @param value [String] One of "GadgetDefinition", "SecurePoll", "MassMessageListContent", "flow-board", "JsonSchema", "wikitext", "javascript", "json", "css", "text", "Scribunto", "wikibase-item", "wikibase-property".
      # @return [self]
      def templatesandboxcontentmodel(value)
        _templatesandboxcontentmodel(value) or fail ArgumentError, "Unknown value for templatesandboxcontentmodel: #{value}"
      end

      # @private
      def _templatesandboxcontentmodel(value)
        defined?(super) && super || ["GadgetDefinition", "SecurePoll", "MassMessageListContent", "flow-board", "JsonSchema", "wikitext", "javascript", "json", "css", "text", "Scribunto", "wikibase-item", "wikibase-property"].include?(value.to_s) && merge(templatesandboxcontentmodel: value.to_s)
      end

      # Content format of templatesandboxtext.
      #
      # @param value [String] One of "application/json", "text/x-wiki", "text/javascript", "text/css", "text/plain", "application/vnd.php.serialized".
      # @return [self]
      def templatesandboxcontentformat(value)
        _templatesandboxcontentformat(value) or fail ArgumentError, "Unknown value for templatesandboxcontentformat: #{value}"
      end

      # @private
      def _templatesandboxcontentformat(value)
        defined?(super) && super || ["application/json", "text/x-wiki", "text/javascript", "text/css", "text/plain", "application/vnd.php.serialized"].include?(value.to_s) && merge(templatesandboxcontentformat: value.to_s)
      end
    end
  end
end
