# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Obtain information about API modules.
    #
    # Usage:
    #
    # ```ruby
    # api.paraminfo.modules(value).perform # returns string with raw output
    # # or
    # api.paraminfo.modules(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Paraminfo < Reality::DataSources::Wikidata::Impl::Actions::Get

      # List of module names (values of the action and format parameters, or main). Can specify submodules with a +, or all submodules with +*, or all submodules recursively with +**.
      #
      # @param values [Array<String>]
      # @return [self]
      def modules(*values)
        values.inject(self) { |res, val| res._modules(val) }
      end

      # @private
      def _modules(value)
        merge(modules: value.to_s, replace: false)
      end

      # Format of help strings.
      #
      # @param value [String] One of "html", "wikitext", "raw", "none".
      # @return [self]
      def helpformat(value)
        _helpformat(value) or fail ArgumentError, "Unknown value for helpformat: #{value}"
      end

      # @private
      def _helpformat(value)
        defined?(super) && super || ["html", "wikitext", "raw", "none"].include?(value.to_s) && merge(helpformat: value.to_s)
      end

      # List of query module names (value of prop, meta or list parameter). Use modules=query+foo instead of querymodules=foo.
      #
      # @param values [Array<String>] Allowed values: "abusefilters", "abuselog", "allcategories", "alldeletedrevisions", "allfileusages", "allimages", "alllinks", "allmessages", "allpages", "allredirects", "allrevisions", "alltransclusions", "allusers", "authmanagerinfo", "babel", "backlinks", "betafeatures", "blocks", "categories", "categoryinfo", "categorymembers", "centralnoticelogs", "checkuser", "checkuserlog", "contributors", "coordinates", "deletedrevisions", "deletedrevs", "duplicatefiles", "embeddedin", "extlinks", "extracts", "exturlusage", "featureusage", "filearchive", "filerepoinfo", "fileusage", "flowinfo", "gadgetcategories", "gadgets", "geosearch", "globalallusers", "globalblocks", "globalgroups", "globalusage", "globaluserinfo", "imageinfo", "images", "imageusage", "info", "iwbacklinks", "iwlinks", "langbacklinks", "langlinks", "languagestats", "links", "linkshere", "logevents", "mapdata", "messagecollection", "messagegroups", "messagegroupstats", "messagetranslations", "mmsites", "mostviewed", "mystashedfiles", "notifications", "oath", "ores", "pageimages", "pagepropnames", "pageprops", "pageswithprop", "pageterms", "pageviews", "prefixsearch", "protectedtitles", "querypage", "random", "recentchanges", "redirects", "references", "revisions", "search", "siteinfo", "siteviews", "stashimageinfo", "tags", "templates", "tokens", "transcludedin", "transcodestatus", "unreadnotificationpages", "usercontribs", "userinfo", "users", "videoinfo", "watchlist", "watchlistraw", "wbentityusage", "wblistentityusage", "wbsearch", "wbsubscribers", "wikibase", "wikisets".
      # @return [self]
      def querymodules(*values)
        values.inject(self) { |res, val| res._querymodules(val) or fail ArgumentError, "Unknown value for querymodules: #{val}" }
      end

      # @private
      def _querymodules(value)
        defined?(super) && super || ["abusefilters", "abuselog", "allcategories", "alldeletedrevisions", "allfileusages", "allimages", "alllinks", "allmessages", "allpages", "allredirects", "allrevisions", "alltransclusions", "allusers", "authmanagerinfo", "babel", "backlinks", "betafeatures", "blocks", "categories", "categoryinfo", "categorymembers", "centralnoticelogs", "checkuser", "checkuserlog", "contributors", "coordinates", "deletedrevisions", "deletedrevs", "duplicatefiles", "embeddedin", "extlinks", "extracts", "exturlusage", "featureusage", "filearchive", "filerepoinfo", "fileusage", "flowinfo", "gadgetcategories", "gadgets", "geosearch", "globalallusers", "globalblocks", "globalgroups", "globalusage", "globaluserinfo", "imageinfo", "images", "imageusage", "info", "iwbacklinks", "iwlinks", "langbacklinks", "langlinks", "languagestats", "links", "linkshere", "logevents", "mapdata", "messagecollection", "messagegroups", "messagegroupstats", "messagetranslations", "mmsites", "mostviewed", "mystashedfiles", "notifications", "oath", "ores", "pageimages", "pagepropnames", "pageprops", "pageswithprop", "pageterms", "pageviews", "prefixsearch", "protectedtitles", "querypage", "random", "recentchanges", "redirects", "references", "revisions", "search", "siteinfo", "siteviews", "stashimageinfo", "tags", "templates", "tokens", "transcludedin", "transcodestatus", "unreadnotificationpages", "usercontribs", "userinfo", "users", "videoinfo", "watchlist", "watchlistraw", "wbentityusage", "wblistentityusage", "wbsearch", "wbsubscribers", "wikibase", "wikisets"].include?(value.to_s) && merge(querymodules: value.to_s, replace: false)
      end

      # Get information about the main (top-level) module as well. Use modules=main instead.
      #
      # @param value [String]
      # @return [self]
      def mainmodule(value)
        merge(mainmodule: value.to_s)
      end

      # Get information about the pageset module (providing titles= and friends) as well.
      #
      # @param value [String]
      # @return [self]
      def pagesetmodule(value)
        merge(pagesetmodule: value.to_s)
      end

      # List of format module names (value of format parameter). Use modules instead.
      #
      # @param values [Array<String>] Allowed values: "json", "jsonfm", "none", "php", "phpfm", "rawfm", "xml", "xmlfm".
      # @return [self]
      def formatmodules(*values)
        values.inject(self) { |res, val| res._formatmodules(val) or fail ArgumentError, "Unknown value for formatmodules: #{val}" }
      end

      # @private
      def _formatmodules(value)
        defined?(super) && super || ["json", "jsonfm", "none", "php", "phpfm", "rawfm", "xml", "xmlfm"].include?(value.to_s) && merge(formatmodules: value.to_s, replace: false)
      end
    end
  end
end
