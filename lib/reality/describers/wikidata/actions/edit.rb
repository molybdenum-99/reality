# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Create and edit pages.
    #
    # Usage:
    #
    # ```ruby
    # api.edit.title(value).perform # returns string with raw output
    # # or
    # api.edit.title(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Edit < Reality::Describers::Wikidata::Impl::Actions::Post

      # Title of the page to edit. Cannot be used together with pageid.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(title: value.to_s)
      end

      # Page ID of the page to edit. Cannot be used together with title.
      #
      # @param value [Integer]
      # @return [self]
      def pageid(value)
        merge(pageid: value.to_s)
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

      # Edit summary. Also section title when section=new and sectiontitle is not set.
      #
      # @param value [String]
      # @return [self]
      def summary(value)
        merge(summary: value.to_s)
      end

      # Change tags to apply to the revision.
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

      # Minor edit.
      #
      # @return [self]
      def minor()
        merge(minor: 'true')
      end

      # Non-minor edit.
      #
      # @return [self]
      def notminor()
        merge(notminor: 'true')
      end

      # Mark this edit as a bot edit.
      #
      # @return [self]
      def bot()
        merge(bot: 'true')
      end

      # Timestamp of the base revision, used to detect edit conflicts. May be obtained through action=query&prop=revisions&rvprop=timestamp.
      #
      # @param value [Time]
      # @return [self]
      def basetimestamp(value)
        merge(basetimestamp: value.iso8601)
      end

      # Timestamp when the editing process began, used to detect edit conflicts. An appropriate value may be obtained using curtimestamp when beginning the edit process (e.g. when loading the page content to edit).
      #
      # @param value [Time]
      # @return [self]
      def starttimestamp(value)
        merge(starttimestamp: value.iso8601)
      end

      # Override any errors about the page having been deleted in the meantime.
      #
      # @return [self]
      def recreate()
        merge(recreate: 'true')
      end

      # Don't edit the page if it exists already.
      #
      # @return [self]
      def createonly()
        merge(createonly: 'true')
      end

      # Throw an error if the page doesn't exist.
      #
      # @return [self]
      def nocreate()
        merge(nocreate: 'true')
      end

      # Add the page to the current user's watchlist.
      #
      # @return [self]
      def watch()
        merge(watch: 'true')
      end

      # Remove the page from the current user's watchlist.
      #
      # @return [self]
      def unwatch()
        merge(unwatch: 'true')
      end

      # Unconditionally add or remove the page from the current user's watchlist, use preferences or do not change watch.
      #
      # @param value [String] One of "watch", "unwatch", "preferences", "nochange".
      # @return [self]
      def watchlist(value)
        _watchlist(value) or fail ArgumentError, "Unknown value for watchlist: #{value}"
      end

      # @private
      def _watchlist(value)
        defined?(super) && super || ["watch", "unwatch", "preferences", "nochange"].include?(value.to_s) && merge(watchlist: value.to_s)
      end

      # The MD5 hash of the text parameter, or the prependtext and appendtext parameters concatenated. If set, the edit won't be done unless the hash is correct.
      #
      # @param value [String]
      # @return [self]
      def md5(value)
        merge(md5: value.to_s)
      end

      # Add this text to the beginning of the page. Overrides text.
      #
      # @param value [String]
      # @return [self]
      def prependtext(value)
        merge(prependtext: value.to_s)
      end

      # Add this text to the end of the page. Overrides text.
      #
      # @param value [String]
      # @return [self]
      def appendtext(value)
        merge(appendtext: value.to_s)
      end

      # Undo this revision. Overrides text, prependtext and appendtext.
      #
      # @param value [Integer]
      # @return [self]
      def undo(value)
        merge(undo: value.to_s)
      end

      # Undo all revisions from undo to this one. If not set, just undo one revision.
      #
      # @param value [Integer]
      # @return [self]
      def undoafter(value)
        merge(undoafter: value.to_s)
      end

      # Automatically resolve redirects.
      #
      # @return [self]
      def redirect()
        merge(redirect: 'true')
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

      # A "csrf" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end

      # Answer to the CAPTCHA
      #
      # @param value [String]
      # @return [self]
      def captchaword(value)
        merge(captchaword: value.to_s)
      end

      # CAPTCHA ID from previous request
      #
      # @param value [String]
      # @return [self]
      def captchaid(value)
        merge(captchaid: value.to_s)
      end
    end
  end
end
