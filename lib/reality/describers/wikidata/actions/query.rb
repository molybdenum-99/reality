# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Fetch data from and about MediaWiki.
    #
    # Usage:
    #
    # ```ruby
    # api.query.prop(value).perform # returns string with raw output
    # # or
    # api.query.prop(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Query < Reality::Describers::Wikidata::Impl::Actions::Get

      # Which properties to get for the queried pages.
      #
      # @param values [Array<Symbol>] All selected options include tweaking methods from corresponding modules:
      #   * `:categories` - {Reality::Describers::Wikidata::Impl::Modules::Categories} List all categories the pages belong to.
      #   * `:categoryinfo` - {Reality::Describers::Wikidata::Impl::Modules::Categoryinfo} Returns information about the given categories.
      #   * `:contributors` - {Reality::Describers::Wikidata::Impl::Modules::Contributors} Get the list of logged-in contributors and the count of anonymous contributors to a page.
      #   * `:coordinates` - {Reality::Describers::Wikidata::Impl::Modules::Coordinates} Returns coordinates of the given pages.
      #   * `:deletedrevisions` - {Reality::Describers::Wikidata::Impl::Modules::Deletedrevisions} Get deleted revision information.
      #   * `:duplicatefiles` - {Reality::Describers::Wikidata::Impl::Modules::Duplicatefiles} List all files that are duplicates of the given files based on hash values.
      #   * `:extlinks` - {Reality::Describers::Wikidata::Impl::Modules::Extlinks} Returns all external URLs (not interwikis) from the given pages.
      #   * `:extracts` - {Reality::Describers::Wikidata::Impl::Modules::Extracts} Returns plain-text or limited HTML extracts of the given pages.
      #   * `:fileusage` - {Reality::Describers::Wikidata::Impl::Modules::Fileusage} Find all pages that use the given files.
      #   * `:flowinfo` - {Reality::Describers::Wikidata::Impl::Modules::Flowinfo} Get basic Flow information about a page.
      #   * `:globalusage` - {Reality::Describers::Wikidata::Impl::Modules::Globalusage} Returns global image usage for a certain image.
      #   * `:imageinfo` - {Reality::Describers::Wikidata::Impl::Modules::Imageinfo} Returns file information and upload history.
      #   * `:images` - {Reality::Describers::Wikidata::Impl::Modules::Images} Returns all files contained on the given pages.
      #   * `:info` - {Reality::Describers::Wikidata::Impl::Modules::Info} Get basic page information.
      #   * `:iwlinks` - {Reality::Describers::Wikidata::Impl::Modules::Iwlinks} Returns all interwiki links from the given pages.
      #   * `:langlinks` - {Reality::Describers::Wikidata::Impl::Modules::Langlinks} Returns all interlanguage links from the given pages.
      #   * `:links` - {Reality::Describers::Wikidata::Impl::Modules::Links} Returns all links from the given pages.
      #   * `:linkshere` - {Reality::Describers::Wikidata::Impl::Modules::Linkshere} Find all pages that link to the given pages.
      #   * `:mapdata` - {Reality::Describers::Wikidata::Impl::Modules::Mapdata} Request all map data from the page Metallica
      #   * `:pageimages` - {Reality::Describers::Wikidata::Impl::Modules::Pageimages} Returns information about images on the page, such as thumbnail and presence of photos.
      #   * `:pageprops` - {Reality::Describers::Wikidata::Impl::Modules::Pageprops} Get various page properties defined in the page content.
      #   * `:pageterms` - {Reality::Describers::Wikidata::Impl::Modules::Pageterms} Get the Wikidata terms (typically labels, descriptions and aliases) associated with a page via a sitelink. On the entity page itself, the terms are used directly. Caveat: On a repo wiki, this module only works directly on entity pages, not on pages connected to an entity via a sitelink. This may change in the future.
      #   * `:pageviews` - {Reality::Describers::Wikidata::Impl::Modules::Pageviews} Shows per-page pageview data (the number of daily pageviews for each of the last pvipdays days). The result format is page title (with underscores) => date (Ymd) => count.
      #   * `:redirects` - {Reality::Describers::Wikidata::Impl::Modules::Redirects} Returns all redirects to the given pages.
      #   * `:references` - {Reality::Describers::Wikidata::Impl::Modules::References} Return a data representation of references associated with the given pages.
      #   * `:revisions` - {Reality::Describers::Wikidata::Impl::Modules::Revisions} Get revision information.
      #   * `:stashimageinfo` - {Reality::Describers::Wikidata::Impl::Modules::Stashimageinfo} Returns file information for stashed files.
      #   * `:templates` - {Reality::Describers::Wikidata::Impl::Modules::Templates} Returns all pages transcluded on the given pages.
      #   * `:transcludedin` - {Reality::Describers::Wikidata::Impl::Modules::Transcludedin} Find all pages that transclude the given pages.
      #   * `:transcodestatus` - {Reality::Describers::Wikidata::Impl::Modules::Transcodestatus} Get transcode status for a given file page.
      #   * `:videoinfo` - {Reality::Describers::Wikidata::Impl::Modules::Videoinfo} Extends imageinfo to include video source (derivatives) information
      #   * `:wbentityusage` - {Reality::Describers::Wikidata::Impl::Modules::Wbentityusage} Returns all entity IDs used in the given pages.
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || [:categories, :categoryinfo, :contributors, :coordinates, :deletedrevisions, :duplicatefiles, :extlinks, :extracts, :fileusage, :flowinfo, :globalusage, :imageinfo, :images, :info, :iwlinks, :langlinks, :links, :linkshere, :mapdata, :pageimages, :pageprops, :pageterms, :pageviews, :redirects, :references, :revisions, :stashimageinfo, :templates, :transcludedin, :transcodestatus, :videoinfo, :wbentityusage].include?(value.to_sym) && merge(prop: value.to_s, replace: false).submodule({categories: Modules::Categories, categoryinfo: Modules::Categoryinfo, contributors: Modules::Contributors, coordinates: Modules::Coordinates, deletedrevisions: Modules::Deletedrevisions, duplicatefiles: Modules::Duplicatefiles, extlinks: Modules::Extlinks, extracts: Modules::Extracts, fileusage: Modules::Fileusage, flowinfo: Modules::Flowinfo, globalusage: Modules::Globalusage, imageinfo: Modules::Imageinfo, images: Modules::Images, info: Modules::Info, iwlinks: Modules::Iwlinks, langlinks: Modules::Langlinks, links: Modules::Links, linkshere: Modules::Linkshere, mapdata: Modules::Mapdata, pageimages: Modules::Pageimages, pageprops: Modules::Pageprops, pageterms: Modules::Pageterms, pageviews: Modules::Pageviews, redirects: Modules::Redirects, references: Modules::References, revisions: Modules::Revisions, stashimageinfo: Modules::Stashimageinfo, templates: Modules::Templates, transcludedin: Modules::Transcludedin, transcodestatus: Modules::Transcodestatus, videoinfo: Modules::Videoinfo, wbentityusage: Modules::Wbentityusage}[value.to_sym])
      end

      # Which lists to get.
      #
      # @param values [Array<Symbol>] All selected options include tweaking methods from corresponding modules:
      #   * `:abusefilters` - {Reality::Describers::Wikidata::Impl::Modules::Abusefilters} Show details of the abuse filters.
      #   * `:abuselog` - {Reality::Describers::Wikidata::Impl::Modules::Abuselog} Show events that were caught by one of the abuse filters.
      #   * `:allcategories` - {Reality::Describers::Wikidata::Impl::Modules::Allcategories} Enumerate all categories.
      #   * `:alldeletedrevisions` - {Reality::Describers::Wikidata::Impl::Modules::Alldeletedrevisions} List all deleted revisions by a user or in a namespace.
      #   * `:allfileusages` - {Reality::Describers::Wikidata::Impl::Modules::Allfileusages} List all file usages, including non-existing.
      #   * `:allimages` - {Reality::Describers::Wikidata::Impl::Modules::Allimages} Enumerate all images sequentially.
      #   * `:alllinks` - {Reality::Describers::Wikidata::Impl::Modules::Alllinks} Enumerate all links that point to a given namespace.
      #   * `:allpages` - {Reality::Describers::Wikidata::Impl::Modules::Allpages} Enumerate all pages sequentially in a given namespace.
      #   * `:allredirects` - {Reality::Describers::Wikidata::Impl::Modules::Allredirects} List all redirects to a namespace.
      #   * `:allrevisions` - {Reality::Describers::Wikidata::Impl::Modules::Allrevisions} List all revisions.
      #   * `:alltransclusions` - {Reality::Describers::Wikidata::Impl::Modules::Alltransclusions} List all transclusions (pages embedded using {{x}}), including non-existing.
      #   * `:allusers` - {Reality::Describers::Wikidata::Impl::Modules::Allusers} Enumerate all registered users.
      #   * `:backlinks` - {Reality::Describers::Wikidata::Impl::Modules::Backlinks} Find all pages that link to the given page.
      #   * `:betafeatures` - {Reality::Describers::Wikidata::Impl::Modules::Betafeatures} List all BetaFeatures
      #   * `:blocks` - {Reality::Describers::Wikidata::Impl::Modules::Blocks} List all blocked users and IP addresses.
      #   * `:categorymembers` - {Reality::Describers::Wikidata::Impl::Modules::Categorymembers} List all pages in a given category.
      #   * `:centralnoticelogs` - {Reality::Describers::Wikidata::Impl::Modules::Centralnoticelogs} Get a log of campaign configuration changes.
      #   * `:checkuser` - {Reality::Describers::Wikidata::Impl::Modules::Checkuser} Check which IP addresses are used by a given username or which usernames are used by a given IP address.
      #   * `:checkuserlog` - {Reality::Describers::Wikidata::Impl::Modules::Checkuserlog} Get entries from the CheckUser log.
      #   * `:deletedrevs` - {Reality::Describers::Wikidata::Impl::Modules::Deletedrevs} List deleted revisions.
      #   * `:embeddedin` - {Reality::Describers::Wikidata::Impl::Modules::Embeddedin} Find all pages that embed (transclude) the given title.
      #   * `:exturlusage` - {Reality::Describers::Wikidata::Impl::Modules::Exturlusage} Enumerate pages that contain a given URL.
      #   * `:filearchive` - {Reality::Describers::Wikidata::Impl::Modules::Filearchive} Enumerate all deleted files sequentially.
      #   * `:gadgetcategories` - {Reality::Describers::Wikidata::Impl::Modules::Gadgetcategories} Returns a list of gadget categories.
      #   * `:gadgets` - {Reality::Describers::Wikidata::Impl::Modules::Gadgets} Returns a list of gadgets used on this wiki.
      #   * `:geosearch` - {Reality::Describers::Wikidata::Impl::Modules::Geosearch} Returns pages having coordinates that are located in a certain area.
      #   * `:globalallusers` - {Reality::Describers::Wikidata::Impl::Modules::Globalallusers} Enumerate all global users.
      #   * `:globalblocks` - {Reality::Describers::Wikidata::Impl::Modules::Globalblocks} List all globally blocked IP addresses.
      #   * `:globalgroups` - {Reality::Describers::Wikidata::Impl::Modules::Globalgroups} Enumerate all global groups.
      #   * `:imageusage` - {Reality::Describers::Wikidata::Impl::Modules::Imageusage} Find all pages that use the given image title.
      #   * `:iwbacklinks` - {Reality::Describers::Wikidata::Impl::Modules::Iwbacklinks} Find all pages that link to the given interwiki link.
      #   * `:langbacklinks` - {Reality::Describers::Wikidata::Impl::Modules::Langbacklinks} Find all pages that link to the given language link.
      #   * `:logevents` - {Reality::Describers::Wikidata::Impl::Modules::Logevents} Get events from logs.
      #   * `:messagecollection` - {Reality::Describers::Wikidata::Impl::Modules::Messagecollection} Query MessageCollection about translations.
      #   * `:mmsites` - {Reality::Describers::Wikidata::Impl::Modules::Mmsites} Serve autocomplete requests for the site field in MassMessage.
      #   * `:mostviewed` - {Reality::Describers::Wikidata::Impl::Modules::Mostviewed} Lists the most viewed pages (based on last day's pageview count).
      #   * `:mystashedfiles` - {Reality::Describers::Wikidata::Impl::Modules::Mystashedfiles} Get a list of files in the current user's upload stash.
      #   * `:pagepropnames` - {Reality::Describers::Wikidata::Impl::Modules::Pagepropnames} List all page property names in use on the wiki.
      #   * `:pageswithprop` - {Reality::Describers::Wikidata::Impl::Modules::Pageswithprop} List all pages using a given page property.
      #   * `:prefixsearch` - {Reality::Describers::Wikidata::Impl::Modules::Prefixsearch} Perform a prefix search for page titles.
      #   * `:protectedtitles` - {Reality::Describers::Wikidata::Impl::Modules::Protectedtitles} List all titles protected from creation.
      #   * `:querypage` - {Reality::Describers::Wikidata::Impl::Modules::Querypage} Get a list provided by a QueryPage-based special page.
      #   * `:random` - {Reality::Describers::Wikidata::Impl::Modules::Random} Get a set of random pages.
      #   * `:recentchanges` - {Reality::Describers::Wikidata::Impl::Modules::Recentchanges} Enumerate recent changes.
      #   * `:search` - {Reality::Describers::Wikidata::Impl::Modules::Search} Perform a full text search.
      #   * `:tags` - {Reality::Describers::Wikidata::Impl::Modules::Tags} List change tags.
      #   * `:usercontribs` - {Reality::Describers::Wikidata::Impl::Modules::Usercontribs} Get all edits by a user.
      #   * `:users` - {Reality::Describers::Wikidata::Impl::Modules::Users} Get information about a list of users.
      #   * `:watchlist` - {Reality::Describers::Wikidata::Impl::Modules::Watchlist} Get recent changes to pages in the current user's watchlist.
      #   * `:watchlistraw` - {Reality::Describers::Wikidata::Impl::Modules::Watchlistraw} Get all pages on the current user's watchlist.
      #   * `:wblistentityusage` - {Reality::Describers::Wikidata::Impl::Modules::Wblistentityusage} Returns all pages that use the given entity IDs.
      #   * `:wbsearch` - {Reality::Describers::Wikidata::Impl::Modules::Wbsearch} Searches for entities using labels and aliases. This can be used as a generator for other queries. Returns the matched term that should be displayed.
      #   * `:wbsubscribers` - {Reality::Describers::Wikidata::Impl::Modules::Wbsubscribers} Get subscriptions to given entities.
      #   * `:wikisets` - {Reality::Describers::Wikidata::Impl::Modules::Wikisets} Enumerate all wiki sets.
      # @return [self]
      def list(*values)
        values.inject(self) { |res, val| res._list(val) or fail ArgumentError, "Unknown value for list: #{val}" }
      end

      # @private
      def _list(value)
        defined?(super) && super || [:abusefilters, :abuselog, :allcategories, :alldeletedrevisions, :allfileusages, :allimages, :alllinks, :allpages, :allredirects, :allrevisions, :alltransclusions, :allusers, :backlinks, :betafeatures, :blocks, :categorymembers, :centralnoticelogs, :checkuser, :checkuserlog, :deletedrevs, :embeddedin, :exturlusage, :filearchive, :gadgetcategories, :gadgets, :geosearch, :globalallusers, :globalblocks, :globalgroups, :imageusage, :iwbacklinks, :langbacklinks, :logevents, :messagecollection, :mmsites, :mostviewed, :mystashedfiles, :pagepropnames, :pageswithprop, :prefixsearch, :protectedtitles, :querypage, :random, :recentchanges, :search, :tags, :usercontribs, :users, :watchlist, :watchlistraw, :wblistentityusage, :wbsearch, :wbsubscribers, :wikisets].include?(value.to_sym) && merge(list: value.to_s, replace: false).submodule({abusefilters: Modules::Abusefilters, abuselog: Modules::Abuselog, allcategories: Modules::Allcategories, alldeletedrevisions: Modules::Alldeletedrevisions, allfileusages: Modules::Allfileusages, allimages: Modules::Allimages, alllinks: Modules::Alllinks, allpages: Modules::Allpages, allredirects: Modules::Allredirects, allrevisions: Modules::Allrevisions, alltransclusions: Modules::Alltransclusions, allusers: Modules::Allusers, backlinks: Modules::Backlinks, betafeatures: Modules::Betafeatures, blocks: Modules::Blocks, categorymembers: Modules::Categorymembers, centralnoticelogs: Modules::Centralnoticelogs, checkuser: Modules::Checkuser, checkuserlog: Modules::Checkuserlog, deletedrevs: Modules::Deletedrevs, embeddedin: Modules::Embeddedin, exturlusage: Modules::Exturlusage, filearchive: Modules::Filearchive, gadgetcategories: Modules::Gadgetcategories, gadgets: Modules::Gadgets, geosearch: Modules::Geosearch, globalallusers: Modules::Globalallusers, globalblocks: Modules::Globalblocks, globalgroups: Modules::Globalgroups, imageusage: Modules::Imageusage, iwbacklinks: Modules::Iwbacklinks, langbacklinks: Modules::Langbacklinks, logevents: Modules::Logevents, messagecollection: Modules::Messagecollection, mmsites: Modules::Mmsites, mostviewed: Modules::Mostviewed, mystashedfiles: Modules::Mystashedfiles, pagepropnames: Modules::Pagepropnames, pageswithprop: Modules::Pageswithprop, prefixsearch: Modules::Prefixsearch, protectedtitles: Modules::Protectedtitles, querypage: Modules::Querypage, random: Modules::Random, recentchanges: Modules::Recentchanges, search: Modules::Search, tags: Modules::Tags, usercontribs: Modules::Usercontribs, users: Modules::Users, watchlist: Modules::Watchlist, watchlistraw: Modules::Watchlistraw, wblistentityusage: Modules::Wblistentityusage, wbsearch: Modules::Wbsearch, wbsubscribers: Modules::Wbsubscribers, wikisets: Modules::Wikisets}[value.to_sym])
      end

      # Which metadata to get.
      #
      # @param values [Array<Symbol>] All selected options include tweaking methods from corresponding modules:
      #   * `:allmessages` - {Reality::Describers::Wikidata::Impl::Modules::Allmessages} Return messages from this site.
      #   * `:authmanagerinfo` - {Reality::Describers::Wikidata::Impl::Modules::Authmanagerinfo} Retrieve information about the current authentication status.
      #   * `:babel` - {Reality::Describers::Wikidata::Impl::Modules::Babel} Get information about what languages the user knows
      #   * `:featureusage` - {Reality::Describers::Wikidata::Impl::Modules::Featureusage} Get a summary of logged API feature usages for a user agent.
      #   * `:filerepoinfo` - {Reality::Describers::Wikidata::Impl::Modules::Filerepoinfo} Return meta information about image repositories configured on the wiki.
      #   * `:globaluserinfo` - {Reality::Describers::Wikidata::Impl::Modules::Globaluserinfo} Show information about a global user.
      #   * `:languagestats` - {Reality::Describers::Wikidata::Impl::Modules::Languagestats} Query language stats.
      #   * `:messagegroups` - {Reality::Describers::Wikidata::Impl::Modules::Messagegroups} Return information about message groups.
      #   * `:messagegroupstats` - {Reality::Describers::Wikidata::Impl::Modules::Messagegroupstats} Query message group stats.
      #   * `:messagetranslations` - {Reality::Describers::Wikidata::Impl::Modules::Messagetranslations} Query all translations for a single message.
      #   * `:notifications` - {Reality::Describers::Wikidata::Impl::Modules::Notifications} Get notifications waiting for the current user.
      #   * `:oath` - {Reality::Describers::Wikidata::Impl::Modules::Oath} Check to see if two-factor authentication (OATH) is enabled for a user.
      #   * `:ores` - {Reality::Describers::Wikidata::Impl::Modules::Ores} Return ORES configuration and model data for this wiki.
      #   * `:siteinfo` - {Reality::Describers::Wikidata::Impl::Modules::Siteinfo} Return general information about the site.
      #   * `:siteviews` - {Reality::Describers::Wikidata::Impl::Modules::Siteviews} Shows sitewide pageview data (daily pageview totals for each of the last pvisdays days). The result format is date (Ymd) => count.
      #   * `:tokens` - {Reality::Describers::Wikidata::Impl::Modules::Tokens} Gets tokens for data-modifying actions.
      #   * `:unreadnotificationpages` - {Reality::Describers::Wikidata::Impl::Modules::Unreadnotificationpages} Get pages for which there are unread notifications for the current user.
      #   * `:userinfo` - {Reality::Describers::Wikidata::Impl::Modules::Userinfo} Get information about the current user.
      #   * `:wikibase` - {Reality::Describers::Wikidata::Impl::Modules::Wikibase} Get information about the Wikibase client and the associated Wikibase repository.
      # @return [self]
      def meta(*values)
        values.inject(self) { |res, val| res._meta(val) or fail ArgumentError, "Unknown value for meta: #{val}" }
      end

      # @private
      def _meta(value)
        defined?(super) && super || [:allmessages, :authmanagerinfo, :babel, :featureusage, :filerepoinfo, :globaluserinfo, :languagestats, :messagegroups, :messagegroupstats, :messagetranslations, :notifications, :oath, :ores, :siteinfo, :siteviews, :tokens, :unreadnotificationpages, :userinfo, :wikibase].include?(value.to_sym) && merge(meta: value.to_s, replace: false).submodule({allmessages: Modules::Allmessages, authmanagerinfo: Modules::Authmanagerinfo, babel: Modules::Babel, featureusage: Modules::Featureusage, filerepoinfo: Modules::Filerepoinfo, globaluserinfo: Modules::Globaluserinfo, languagestats: Modules::Languagestats, messagegroups: Modules::Messagegroups, messagegroupstats: Modules::Messagegroupstats, messagetranslations: Modules::Messagetranslations, notifications: Modules::Notifications, oath: Modules::Oath, ores: Modules::Ores, siteinfo: Modules::Siteinfo, siteviews: Modules::Siteviews, tokens: Modules::Tokens, unreadnotificationpages: Modules::Unreadnotificationpages, userinfo: Modules::Userinfo, wikibase: Modules::Wikibase}[value.to_sym])
      end

      # Include an additional pageids section listing all returned page IDs.
      #
      # @return [self]
      def indexpageids()
        merge(indexpageids: 'true')
      end

      # Export the current revisions of all given or generated pages.
      #
      # @return [self]
      def export()
        merge(export: 'true')
      end

      # Return the export XML without wrapping it in an XML result (same format as Special:Export). Can only be used with export.
      #
      # @return [self]
      def exportnowrap()
        merge(exportnowrap: 'true')
      end

      # Whether to get the full URL if the title is an interwiki link.
      #
      # @return [self]
      def iwurl()
        merge(iwurl: 'true')
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(continue: value.to_s)
      end

      # Return raw query-continue data for continuation.
      #
      # @return [self]
      def rawcontinue()
        merge(rawcontinue: 'true')
      end

      # A list of titles to work on.
      #
      # @param values [Array<String>]
      # @return [self]
      def titles(*values)
        values.inject(self) { |res, val| res._titles(val) }
      end

      # @private
      def _titles(value)
        merge(titles: value.to_s, replace: false)
      end

      # A list of page IDs to work on.
      #
      # @param values [Array<Integer>]
      # @return [self]
      def pageids(*values)
        values.inject(self) { |res, val| res._pageids(val) }
      end

      # @private
      def _pageids(value)
        merge(pageids: value.to_s, replace: false)
      end

      # A list of revision IDs to work on.
      #
      # @param values [Array<Integer>]
      # @return [self]
      def revids(*values)
        values.inject(self) { |res, val| res._revids(val) }
      end

      # @private
      def _revids(value)
        merge(revids: value.to_s, replace: false)
      end

      # Get the list of pages to work on by executing the specified query module.
      #
      # @param value [Symbol] Selecting an option includes tweaking methods from corresponding module:
      #   * `:allcategories` - {Reality::Describers::Wikidata::Impl::Modules::GAllcategories} Enumerate all categories. _Generator module: for fetching pages corresponding to request._
      #   * `:alldeletedrevisions` - {Reality::Describers::Wikidata::Impl::Modules::GAlldeletedrevisions} List all deleted revisions by a user or in a namespace. _Generator module: for fetching pages corresponding to request._
      #   * `:allfileusages` - {Reality::Describers::Wikidata::Impl::Modules::GAllfileusages} List all file usages, including non-existing. _Generator module: for fetching pages corresponding to request._
      #   * `:allimages` - {Reality::Describers::Wikidata::Impl::Modules::GAllimages} Enumerate all images sequentially. _Generator module: for fetching pages corresponding to request._
      #   * `:alllinks` - {Reality::Describers::Wikidata::Impl::Modules::GAlllinks} Enumerate all links that point to a given namespace. _Generator module: for fetching pages corresponding to request._
      #   * `:allpages` - {Reality::Describers::Wikidata::Impl::Modules::GAllpages} Enumerate all pages sequentially in a given namespace. _Generator module: for fetching pages corresponding to request._
      #   * `:allredirects` - {Reality::Describers::Wikidata::Impl::Modules::GAllredirects} List all redirects to a namespace. _Generator module: for fetching pages corresponding to request._
      #   * `:allrevisions` - {Reality::Describers::Wikidata::Impl::Modules::GAllrevisions} List all revisions. _Generator module: for fetching pages corresponding to request._
      #   * `:alltransclusions` - {Reality::Describers::Wikidata::Impl::Modules::GAlltransclusions} List all transclusions (pages embedded using {{x}}), including non-existing. _Generator module: for fetching pages corresponding to request._
      #   * `:backlinks` - {Reality::Describers::Wikidata::Impl::Modules::GBacklinks} Find all pages that link to the given page. _Generator module: for fetching pages corresponding to request._
      #   * `:categories` - {Reality::Describers::Wikidata::Impl::Modules::GCategories} List all categories the pages belong to. _Generator module: for fetching pages corresponding to request._
      #   * `:categorymembers` - {Reality::Describers::Wikidata::Impl::Modules::GCategorymembers} List all pages in a given category. _Generator module: for fetching pages corresponding to request._
      #   * `:deletedrevisions` - {Reality::Describers::Wikidata::Impl::Modules::GDeletedrevisions} Get deleted revision information. _Generator module: for fetching pages corresponding to request._
      #   * `:duplicatefiles` - {Reality::Describers::Wikidata::Impl::Modules::GDuplicatefiles} List all files that are duplicates of the given files based on hash values. _Generator module: for fetching pages corresponding to request._
      #   * `:embeddedin` - {Reality::Describers::Wikidata::Impl::Modules::GEmbeddedin} Find all pages that embed (transclude) the given title. _Generator module: for fetching pages corresponding to request._
      #   * `:exturlusage` - {Reality::Describers::Wikidata::Impl::Modules::GExturlusage} Enumerate pages that contain a given URL. _Generator module: for fetching pages corresponding to request._
      #   * `:fileusage` - {Reality::Describers::Wikidata::Impl::Modules::GFileusage} Find all pages that use the given files. _Generator module: for fetching pages corresponding to request._
      #   * `:geosearch` - {Reality::Describers::Wikidata::Impl::Modules::GGeosearch} Returns pages having coordinates that are located in a certain area. _Generator module: for fetching pages corresponding to request._
      #   * `:images` - {Reality::Describers::Wikidata::Impl::Modules::GImages} Returns all files contained on the given pages. _Generator module: for fetching pages corresponding to request._
      #   * `:imageusage` - {Reality::Describers::Wikidata::Impl::Modules::GImageusage} Find all pages that use the given image title. _Generator module: for fetching pages corresponding to request._
      #   * `:iwbacklinks` - {Reality::Describers::Wikidata::Impl::Modules::GIwbacklinks} Find all pages that link to the given interwiki link. _Generator module: for fetching pages corresponding to request._
      #   * `:langbacklinks` - {Reality::Describers::Wikidata::Impl::Modules::GLangbacklinks} Find all pages that link to the given language link. _Generator module: for fetching pages corresponding to request._
      #   * `:links` - {Reality::Describers::Wikidata::Impl::Modules::GLinks} Returns all links from the given pages. _Generator module: for fetching pages corresponding to request._
      #   * `:linkshere` - {Reality::Describers::Wikidata::Impl::Modules::GLinkshere} Find all pages that link to the given pages. _Generator module: for fetching pages corresponding to request._
      #   * `:messagecollection` - {Reality::Describers::Wikidata::Impl::Modules::GMessagecollection} Query MessageCollection about translations. _Generator module: for fetching pages corresponding to request._
      #   * `:mostviewed` - {Reality::Describers::Wikidata::Impl::Modules::GMostviewed} Lists the most viewed pages (based on last day's pageview count). _Generator module: for fetching pages corresponding to request._
      #   * `:pageswithprop` - {Reality::Describers::Wikidata::Impl::Modules::GPageswithprop} List all pages using a given page property. _Generator module: for fetching pages corresponding to request._
      #   * `:prefixsearch` - {Reality::Describers::Wikidata::Impl::Modules::GPrefixsearch} Perform a prefix search for page titles. _Generator module: for fetching pages corresponding to request._
      #   * `:protectedtitles` - {Reality::Describers::Wikidata::Impl::Modules::GProtectedtitles} List all titles protected from creation. _Generator module: for fetching pages corresponding to request._
      #   * `:querypage` - {Reality::Describers::Wikidata::Impl::Modules::GQuerypage} Get a list provided by a QueryPage-based special page. _Generator module: for fetching pages corresponding to request._
      #   * `:random` - {Reality::Describers::Wikidata::Impl::Modules::GRandom} Get a set of random pages. _Generator module: for fetching pages corresponding to request._
      #   * `:recentchanges` - {Reality::Describers::Wikidata::Impl::Modules::GRecentchanges} Enumerate recent changes. _Generator module: for fetching pages corresponding to request._
      #   * `:redirects` - {Reality::Describers::Wikidata::Impl::Modules::GRedirects} Returns all redirects to the given pages. _Generator module: for fetching pages corresponding to request._
      #   * `:revisions` - {Reality::Describers::Wikidata::Impl::Modules::GRevisions} Get revision information. _Generator module: for fetching pages corresponding to request._
      #   * `:search` - {Reality::Describers::Wikidata::Impl::Modules::GSearch} Perform a full text search. _Generator module: for fetching pages corresponding to request._
      #   * `:templates` - {Reality::Describers::Wikidata::Impl::Modules::GTemplates} Returns all pages transcluded on the given pages. _Generator module: for fetching pages corresponding to request._
      #   * `:transcludedin` - {Reality::Describers::Wikidata::Impl::Modules::GTranscludedin} Find all pages that transclude the given pages. _Generator module: for fetching pages corresponding to request._
      #   * `:watchlist` - {Reality::Describers::Wikidata::Impl::Modules::GWatchlist} Get recent changes to pages in the current user's watchlist. _Generator module: for fetching pages corresponding to request._
      #   * `:watchlistraw` - {Reality::Describers::Wikidata::Impl::Modules::GWatchlistraw} Get all pages on the current user's watchlist. _Generator module: for fetching pages corresponding to request._
      #   * `:wblistentityusage` - {Reality::Describers::Wikidata::Impl::Modules::GWblistentityusage} Returns all pages that use the given entity IDs. _Generator module: for fetching pages corresponding to request._
      #   * `:wbsearch` - {Reality::Describers::Wikidata::Impl::Modules::GWbsearch} Searches for entities using labels and aliases. This can be used as a generator for other queries. Returns the matched term that should be displayed. _Generator module: for fetching pages corresponding to request._
      # @return [self]
      def generator(value)
        _generator(value) or fail ArgumentError, "Unknown value for generator: #{value}"
      end

      # @private
      def _generator(value)
        defined?(super) && super || [:allcategories, :alldeletedrevisions, :allfileusages, :allimages, :alllinks, :allpages, :allredirects, :allrevisions, :alltransclusions, :backlinks, :categories, :categorymembers, :deletedrevisions, :duplicatefiles, :embeddedin, :exturlusage, :fileusage, :geosearch, :images, :imageusage, :iwbacklinks, :langbacklinks, :links, :linkshere, :messagecollection, :mostviewed, :pageswithprop, :prefixsearch, :protectedtitles, :querypage, :random, :recentchanges, :redirects, :revisions, :search, :templates, :transcludedin, :watchlist, :watchlistraw, :wblistentityusage, :wbsearch].include?(value.to_sym) && merge(generator: value.to_s).submodule({allcategories: Modules::GAllcategories, alldeletedrevisions: Modules::GAlldeletedrevisions, allfileusages: Modules::GAllfileusages, allimages: Modules::GAllimages, alllinks: Modules::GAlllinks, allpages: Modules::GAllpages, allredirects: Modules::GAllredirects, allrevisions: Modules::GAllrevisions, alltransclusions: Modules::GAlltransclusions, backlinks: Modules::GBacklinks, categories: Modules::GCategories, categorymembers: Modules::GCategorymembers, deletedrevisions: Modules::GDeletedrevisions, duplicatefiles: Modules::GDuplicatefiles, embeddedin: Modules::GEmbeddedin, exturlusage: Modules::GExturlusage, fileusage: Modules::GFileusage, geosearch: Modules::GGeosearch, images: Modules::GImages, imageusage: Modules::GImageusage, iwbacklinks: Modules::GIwbacklinks, langbacklinks: Modules::GLangbacklinks, links: Modules::GLinks, linkshere: Modules::GLinkshere, messagecollection: Modules::GMessagecollection, mostviewed: Modules::GMostviewed, pageswithprop: Modules::GPageswithprop, prefixsearch: Modules::GPrefixsearch, protectedtitles: Modules::GProtectedtitles, querypage: Modules::GQuerypage, random: Modules::GRandom, recentchanges: Modules::GRecentchanges, redirects: Modules::GRedirects, revisions: Modules::GRevisions, search: Modules::GSearch, templates: Modules::GTemplates, transcludedin: Modules::GTranscludedin, watchlist: Modules::GWatchlist, watchlistraw: Modules::GWatchlistraw, wblistentityusage: Modules::GWblistentityusage, wbsearch: Modules::GWbsearch}[value.to_sym])
      end

      # Automatically resolve redirects in titles, pageids, and revids, and in pages returned by generator.
      #
      # @return [self]
      def redirects()
        merge(redirects: 'true')
      end

      # Convert titles to other variants if necessary. Only works if the wiki's content language supports variant conversion. Languages that support variant conversion include gan, iu, kk, ku, shi, sr, tg, uz and zh.
      #
      # @return [self]
      def converttitles()
        merge(converttitles: 'true')
      end
    end
  end
end
