# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Save an HTML5 page to MediaWiki (converted to wikitext via the Parsoid service).
    #
    # Usage:
    #
    # ```ruby
    # api.visualeditoredit.paction(value).perform # returns string with raw output
    # # or
    # api.visualeditoredit.paction(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Visualeditoredit < Reality::Describers::Wikidata::Impl::Actions::Post

      # Action to perform.
      #
      # @param value [String] One of "serialize", "serializeforcache", "diff", "save".
      # @return [self]
      def paction(value)
        _paction(value) or fail ArgumentError, "Unknown value for paction: #{value}"
      end

      # @private
      def _paction(value)
        defined?(super) && super || ["serialize", "serializeforcache", "diff", "save"].include?(value.to_s) && merge(paction: value.to_s)
      end

      # The page to perform actions on.
      #
      # @param value [String]
      # @return [self]
      def page(value)
        merge(page: value.to_s)
      end

      # A "csrf" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end

      # 
      #
      # @param value [String]
      # @return [self]
      def wikitext(value)
        merge(wikitext: value.to_s)
      end

      # The section on which to act.
      #
      # @param value [String]
      # @return [self]
      def section(value)
        merge(section: value.to_s)
      end

      # Title for new section.
      #
      # @param value [String]
      # @return [self]
      def sectiontitle(value)
        merge(sectiontitle: value.to_s)
      end

      # When saving, set this to the timestamp of the revision that was edited. Used to detect edit conflicts.
      #
      # @param value [String]
      # @return [self]
      def basetimestamp(value)
        merge(basetimestamp: value.to_s)
      end

      # When saving, set this to the timestamp of when the page was loaded. Used to detect edit conflicts.
      #
      # @param value [String]
      # @return [self]
      def starttimestamp(value)
        merge(starttimestamp: value.to_s)
      end

      # The revision number to use. Defaults to latest revision. Use 0 for a new page.
      #
      # @param value [String]
      # @return [self]
      def oldid(value)
        merge(oldid: value.to_s)
      end

      # Flag for minor edit.
      #
      # @param value [String]
      # @return [self]
      def minor(value)
        merge(minor: value.to_s)
      end

      # 
      #
      # @param value [String]
      # @return [self]
      def watch(value)
        merge(watch: value.to_s)
      end

      # HTML to send to Parsoid in exchange for wikitext.
      #
      # @param value [String]
      # @return [self]
      def html(value)
        merge(html: value.to_s)
      end

      # ETag to send.
      #
      # @param value [String]
      # @return [self]
      def etag(value)
        merge(etag: value.to_s)
      end

      # Edit summary.
      #
      # @param value [String]
      # @return [self]
      def summary(value)
        merge(summary: value.to_s)
      end

      # Captcha ID (when saving with a captcha response).
      #
      # @param value [String]
      # @return [self]
      def captchaid(value)
        merge(captchaid: value.to_s)
      end

      # Answer to the captcha (when saving with a captcha response).
      #
      # @param value [String]
      # @return [self]
      def captchaword(value)
        merge(captchaword: value.to_s)
      end

      # Use the result of a previous serializeforcache request with this key. Overrides html.
      #
      # @param value [String]
      # @return [self]
      def cachekey(value)
        merge(cachekey: value.to_s)
      end
    end
  end
end
