# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Returns a user contributions feed.
    #
    # Usage:
    #
    # ```ruby
    # api.feedcontributions.feedformat(value).perform # returns string with raw output
    # # or
    # api.feedcontributions.feedformat(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Feedcontributions < Reality::Describers::Wikidata::Impl::Actions::Get

      # The format of the feed.
      #
      # @param value [String] One of "rss", "atom".
      # @return [self]
      def feedformat(value)
        _feedformat(value) or fail ArgumentError, "Unknown value for feedformat: #{value}"
      end

      # @private
      def _feedformat(value)
        defined?(super) && super || ["rss", "atom"].include?(value.to_s) && merge(feedformat: value.to_s)
      end

      # What users to get the contributions for.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(user: value.to_s)
      end

      # Which namespace to filter the contributions by.
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

      # From year (and earlier).
      #
      # @param value [Integer]
      # @return [self]
      def year(value)
        merge(year: value.to_s)
      end

      # From month (and earlier).
      #
      # @param value [Integer]
      # @return [self]
      def month(value)
        merge(month: value.to_s)
      end

      # Filter contributions that have these tags.
      #
      # @param values [Array<String>] Allowed values: "InfoboxExport gadget", "WE-Framework gadget", "meta spam id", "blanking", "emoji", "repeated xwiki abuse", "OTRS permission added by non-OTRS member", "possible spambot (testing)", "ntsamr (global)", "repeated xwiki CoI abuse", "unsourced ethnicity addition by IP", "died", "unexpected value for phone number", "possible spam", "new editor changing statement", "possible vandalism", "possible non-constructive description", "description ending with punctuation", "wikisyntax", "new editor removing statement", "removal of gender property", "redirect removed", "Sitelink deleted in local wiki", "redirect created", "self-referencing", "adding non-latin script language description in latin script", "possible test edit", "adding potentially mistaken label/description/alias", "adding Qid as label/description/alias", "adding invalid links", "URL in item", "adding latin script language description in non-latin script", "merged item", "adding obsolete/deprecated property", "Ntsamr", "Unexpected value for IMDb identifier", "Unexpected value for IUCN conservation status", "Unexpected value for gender", "new editor removing sitelink", "adding language as label/description/alias", "requested for deletion", "mw-contentmodelchange", "massmessage-delivery", "visualeditor", "visualeditor-needcheck", "visualeditor-switched", "visualeditor-wikitext", "mobile edit", "mobile app edit", "mobile web edit", "HHVM", "OAuth CID: 168", "OAuth CID: 25", "OAuth CID: 29", "OAuth CID: 323", "OAuth CID: 336", "OAuth CID: 351", "OAuth CID: 357", "OAuth CID: 378", "OAuth CID: 408", "OAuth CID: 429", "OAuth CID: 454", "OAuth CID: 484", "OAuth CID: 593", "OAuth CID: 619", "OAuth CID: 639", "OAuth CID: 653", "OAuth CID: 657", "OAuth CID: 67", "OAuth CID: 68", "OAuth CID: 699", "OAuth CID: 722", "OAuth CID: 804", "OAuth CID: 809", "OAuth CID: 812", "OAuth CID: 815", "OAuth CID: 93", "OAuth CID: 94".
      # @return [self]
      def tagfilter(*values)
        values.inject(self) { |res, val| res._tagfilter(val) or fail ArgumentError, "Unknown value for tagfilter: #{val}" }
      end

      # @private
      def _tagfilter(value)
        defined?(super) && super || ["InfoboxExport gadget", "WE-Framework gadget", "meta spam id", "blanking", "emoji", "repeated xwiki abuse", "OTRS permission added by non-OTRS member", "possible spambot (testing)", "ntsamr (global)", "repeated xwiki CoI abuse", "unsourced ethnicity addition by IP", "died", "unexpected value for phone number", "possible spam", "new editor changing statement", "possible vandalism", "possible non-constructive description", "description ending with punctuation", "wikisyntax", "new editor removing statement", "removal of gender property", "redirect removed", "Sitelink deleted in local wiki", "redirect created", "self-referencing", "adding non-latin script language description in latin script", "possible test edit", "adding potentially mistaken label/description/alias", "adding Qid as label/description/alias", "adding invalid links", "URL in item", "adding latin script language description in non-latin script", "merged item", "adding obsolete/deprecated property", "Ntsamr", "Unexpected value for IMDb identifier", "Unexpected value for IUCN conservation status", "Unexpected value for gender", "new editor removing sitelink", "adding language as label/description/alias", "requested for deletion", "mw-contentmodelchange", "massmessage-delivery", "visualeditor", "visualeditor-needcheck", "visualeditor-switched", "visualeditor-wikitext", "mobile edit", "mobile app edit", "mobile web edit", "HHVM", "OAuth CID: 168", "OAuth CID: 25", "OAuth CID: 29", "OAuth CID: 323", "OAuth CID: 336", "OAuth CID: 351", "OAuth CID: 357", "OAuth CID: 378", "OAuth CID: 408", "OAuth CID: 429", "OAuth CID: 454", "OAuth CID: 484", "OAuth CID: 593", "OAuth CID: 619", "OAuth CID: 639", "OAuth CID: 653", "OAuth CID: 657", "OAuth CID: 67", "OAuth CID: 68", "OAuth CID: 699", "OAuth CID: 722", "OAuth CID: 804", "OAuth CID: 809", "OAuth CID: 812", "OAuth CID: 815", "OAuth CID: 93", "OAuth CID: 94"].include?(value.to_s) && merge(tagfilter: value.to_s, replace: false)
      end

      # Show only deleted contributions.
      #
      # @return [self]
      def deletedonly()
        merge(deletedonly: 'true')
      end

      # Only show edits that are the latest revisions.
      #
      # @return [self]
      def toponly()
        merge(toponly: 'true')
      end

      # Only show edits that are page creations.
      #
      # @return [self]
      def newonly()
        merge(newonly: 'true')
      end

      # Hide minor edits.
      #
      # @return [self]
      def hideminor()
        merge(hideminor: 'true')
      end

      # Disabled due to miser mode.
      #
      # @return [self]
      def showsizediff()
        merge(showsizediff: 'true')
      end
    end
  end
end
