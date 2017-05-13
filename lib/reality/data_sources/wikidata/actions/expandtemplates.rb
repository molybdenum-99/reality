# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Expands all templates within wikitext.
    #
    # Usage:
    #
    # ```ruby
    # api.expandtemplates.title(value).perform # returns string with raw output
    # # or
    # api.expandtemplates.title(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Expandtemplates < Reality::DataSources::Wikidata::Impl::Actions::Get

      # Title of page.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(title: value.to_s)
      end

      # Wikitext to convert.
      #
      # @param value [String]
      # @return [self]
      def text(value)
        merge(text: value.to_s)
      end

      # Revision ID, for {{REVISIONID}} and similar variables.
      #
      # @param value [Integer]
      # @return [self]
      def revid(value)
        merge(revid: value.to_s)
      end

      # Which pieces of information to get.
      #
      # @param values [Array<String>] Allowed values: "wikitext" (The expanded wikitext), "categories" (Any categories present in the input that are not represented in the wikitext output), "properties" (Page properties defined by expanded magic words in the wikitext), "volatile" (Whether the output is volatile and should not be reused elsewhere within the page), "ttl" (The maximum time after which caches of the result should be invalidated), "modules" (Any ResourceLoader modules that parser functions have requested be added to the output. Either jsconfigvars or encodedjsconfigvars must be requested jointly with modules), "jsconfigvars" (Gives the JavaScript configuration variables specific to the page), "encodedjsconfigvars" (Gives the JavaScript configuration variables specific to the page as a JSON string), "parsetree" (The XML parse tree of the input).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["wikitext", "categories", "properties", "volatile", "ttl", "modules", "jsconfigvars", "encodedjsconfigvars", "parsetree"].include?(value.to_s) && merge(prop: value.to_s, replace: false)
      end

      # Whether to include HTML comments in the output.
      #
      # @return [self]
      def includecomments()
        merge(includecomments: 'true')
      end

      # Generate XML parse tree (replaced by prop=parsetree).
      #
      # @return [self]
      def generatexml()
        merge(generatexml: 'true')
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
