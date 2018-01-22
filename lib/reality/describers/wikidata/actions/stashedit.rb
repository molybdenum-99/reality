# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Prepare an edit in shared cache.
    #
    # Usage:
    #
    # ```ruby
    # api.stashedit.title(value).perform # returns string with raw output
    # # or
    # api.stashedit.title(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Stashedit < Reality::DataSources::Wikidata::Impl::Actions::Post

      # Title of the page being edited.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(title: value.to_s)
      end

      # Section number. 0 for the top section, new for a new section.
      #
      # @param value [String]
      # @return [self]
      def section(value)
        merge(section: value.to_s)
      end

      # The title for a new section.
      #
      # @param value [String]
      # @return [self]
      def sectiontitle(value)
        merge(sectiontitle: value.to_s)
      end

      # Page content.
      #
      # @param value [String]
      # @return [self]
      def text(value)
        merge(text: value.to_s)
      end

      # Page content hash from a prior stash to use instead.
      #
      # @param value [String]
      # @return [self]
      def stashedtexthash(value)
        merge(stashedtexthash: value.to_s)
      end

      # Change summary.
      #
      # @param value [String]
      # @return [self]
      def summary(value)
        merge(summary: value.to_s)
      end

      # Content model of the new content.
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

      # Content serialization format used for the input text.
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

      # Revision ID of the base revision.
      #
      # @param value [Integer]
      # @return [self]
      def baserevid(value)
        merge(baserevid: value.to_s)
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
