# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Fetch data stored by the TemplateData extension.
    #
    # Usage:
    #
    # ```ruby
    # api.templatedata.titles(value).perform # returns string with raw output
    # # or
    # api.templatedata.titles(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Templatedata < Reality::DataSources::Wikidata::Impl::Actions::Get

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
      #   * `:allcategories` - {Reality::DataSources::Wikidata::Impl::Modules::Allcategories} Enumerate all categories.
      #   * `:alldeletedrevisions` - {Reality::DataSources::Wikidata::Impl::Modules::Alldeletedrevisions} List all deleted revisions by a user or in a namespace.
      #   * `:allfileusages` - {Reality::DataSources::Wikidata::Impl::Modules::Allfileusages} List all file usages, including non-existing.
      #   * `:allimages` - {Reality::DataSources::Wikidata::Impl::Modules::Allimages} Enumerate all images sequentially.
      #   * `:alllinks` - {Reality::DataSources::Wikidata::Impl::Modules::Alllinks} Enumerate all links that point to a given namespace.
      #   * `:allpages` - {Reality::DataSources::Wikidata::Impl::Modules::Allpages} Enumerate all pages sequentially in a given namespace.
      #   * `:allredirects` - {Reality::DataSources::Wikidata::Impl::Modules::Allredirects} List all redirects to a namespace.
      #   * `:allrevisions` - {Reality::DataSources::Wikidata::Impl::Modules::Allrevisions} List all revisions.
      #   * `:alltransclusions` - {Reality::DataSources::Wikidata::Impl::Modules::Alltransclusions} List all transclusions (pages embedded using {{x}}), including non-existing.
      #   * `:backlinks` - {Reality::DataSources::Wikidata::Impl::Modules::Backlinks} Find all pages that link to the given page.
      #   * `:categories` - {Reality::DataSources::Wikidata::Impl::Modules::Categories} List all categories the pages belong to.
      #   * `:categorymembers` - {Reality::DataSources::Wikidata::Impl::Modules::Categorymembers} List all pages in a given category.
      #   * `:deletedrevisions` - {Reality::DataSources::Wikidata::Impl::Modules::Deletedrevisions} Get deleted revision information.
      #   * `:duplicatefiles` - {Reality::DataSources::Wikidata::Impl::Modules::Duplicatefiles} List all files that are duplicates of the given files based on hash values.
      #   * `:embeddedin` - {Reality::DataSources::Wikidata::Impl::Modules::Embeddedin} Find all pages that embed (transclude) the given title.
      #   * `:exturlusage` - {Reality::DataSources::Wikidata::Impl::Modules::Exturlusage} Enumerate pages that contain a given URL.
      #   * `:fileusage` - {Reality::DataSources::Wikidata::Impl::Modules::Fileusage} Find all pages that use the given files.
      #   * `:geosearch` - {Reality::DataSources::Wikidata::Impl::Modules::Geosearch} Returns pages having coordinates that are located in a certain area.
      #   * `:images` - {Reality::DataSources::Wikidata::Impl::Modules::Images} Returns all files contained on the given pages.
      #   * `:imageusage` - {Reality::DataSources::Wikidata::Impl::Modules::Imageusage} Find all pages that use the given image title.
      #   * `:iwbacklinks` - {Reality::DataSources::Wikidata::Impl::Modules::Iwbacklinks} Find all pages that link to the given interwiki link.
      #   * `:langbacklinks` - {Reality::DataSources::Wikidata::Impl::Modules::Langbacklinks} Find all pages that link to the given language link.
      #   * `:links` - {Reality::DataSources::Wikidata::Impl::Modules::Links} Returns all links from the given pages.
      #   * `:linkshere` - {Reality::DataSources::Wikidata::Impl::Modules::Linkshere} Find all pages that link to the given pages.
      #   * `:messagecollection` - {Reality::DataSources::Wikidata::Impl::Modules::Messagecollection} Query MessageCollection about translations.
      #   * `:mostviewed` - {Reality::DataSources::Wikidata::Impl::Modules::Mostviewed} Lists the most viewed pages (based on last day's pageview count).
      #   * `:pageswithprop` - {Reality::DataSources::Wikidata::Impl::Modules::Pageswithprop} List all pages using a given page property.
      #   * `:prefixsearch` - {Reality::DataSources::Wikidata::Impl::Modules::Prefixsearch} Perform a prefix search for page titles.
      #   * `:protectedtitles` - {Reality::DataSources::Wikidata::Impl::Modules::Protectedtitles} List all titles protected from creation.
      #   * `:querypage` - {Reality::DataSources::Wikidata::Impl::Modules::Querypage} Get a list provided by a QueryPage-based special page.
      #   * `:random` - {Reality::DataSources::Wikidata::Impl::Modules::Random} Get a set of random pages.
      #   * `:recentchanges` - {Reality::DataSources::Wikidata::Impl::Modules::Recentchanges} Enumerate recent changes.
      #   * `:redirects` - {Reality::DataSources::Wikidata::Impl::Modules::Redirects} Returns all redirects to the given pages.
      #   * `:revisions` - {Reality::DataSources::Wikidata::Impl::Modules::Revisions} Get revision information.
      #   * `:search` - {Reality::DataSources::Wikidata::Impl::Modules::Search} Perform a full text search.
      #   * `:templates` - {Reality::DataSources::Wikidata::Impl::Modules::Templates} Returns all pages transcluded on the given pages.
      #   * `:transcludedin` - {Reality::DataSources::Wikidata::Impl::Modules::Transcludedin} Find all pages that transclude the given pages.
      #   * `:watchlist` - {Reality::DataSources::Wikidata::Impl::Modules::Watchlist} Get recent changes to pages in the current user's watchlist.
      #   * `:watchlistraw` - {Reality::DataSources::Wikidata::Impl::Modules::Watchlistraw} Get all pages on the current user's watchlist.
      #   * `:wblistentityusage` - {Reality::DataSources::Wikidata::Impl::Modules::Wblistentityusage} Returns all pages that use the given entity IDs.
      #   * `:wbsearch` - {Reality::DataSources::Wikidata::Impl::Modules::Wbsearch} Searches for entities using labels and aliases. This can be used as a generator for other queries. Returns the matched term that should be displayed.
      # @return [self]
      def generator(value)
        _generator(value) or fail ArgumentError, "Unknown value for generator: #{value}"
      end

      # @private
      def _generator(value)
        defined?(super) && super || [:allcategories, :alldeletedrevisions, :allfileusages, :allimages, :alllinks, :allpages, :allredirects, :allrevisions, :alltransclusions, :backlinks, :categories, :categorymembers, :deletedrevisions, :duplicatefiles, :embeddedin, :exturlusage, :fileusage, :geosearch, :images, :imageusage, :iwbacklinks, :langbacklinks, :links, :linkshere, :messagecollection, :mostviewed, :pageswithprop, :prefixsearch, :protectedtitles, :querypage, :random, :recentchanges, :redirects, :revisions, :search, :templates, :transcludedin, :watchlist, :watchlistraw, :wblistentityusage, :wbsearch].include?(value.to_sym) && merge(generator: value.to_s).submodule({allcategories: Modules::Allcategories, alldeletedrevisions: Modules::Alldeletedrevisions, allfileusages: Modules::Allfileusages, allimages: Modules::Allimages, alllinks: Modules::Alllinks, allpages: Modules::Allpages, allredirects: Modules::Allredirects, allrevisions: Modules::Allrevisions, alltransclusions: Modules::Alltransclusions, backlinks: Modules::Backlinks, categories: Modules::Categories, categorymembers: Modules::Categorymembers, deletedrevisions: Modules::Deletedrevisions, duplicatefiles: Modules::Duplicatefiles, embeddedin: Modules::Embeddedin, exturlusage: Modules::Exturlusage, fileusage: Modules::Fileusage, geosearch: Modules::Geosearch, images: Modules::Images, imageusage: Modules::Imageusage, iwbacklinks: Modules::Iwbacklinks, langbacklinks: Modules::Langbacklinks, links: Modules::Links, linkshere: Modules::Linkshere, messagecollection: Modules::Messagecollection, mostviewed: Modules::Mostviewed, pageswithprop: Modules::Pageswithprop, prefixsearch: Modules::Prefixsearch, protectedtitles: Modules::Protectedtitles, querypage: Modules::Querypage, random: Modules::Random, recentchanges: Modules::Recentchanges, redirects: Modules::Redirects, revisions: Modules::Revisions, search: Modules::Search, templates: Modules::Templates, transcludedin: Modules::Transcludedin, watchlist: Modules::Watchlist, watchlistraw: Modules::Watchlistraw, wblistentityusage: Modules::Wblistentityusage, wbsearch: Modules::Wbsearch}[value.to_sym])
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

      # Return data about titles even if they are missing or lack TemplateData. By default (for backwards compatibility) titles are only returned if they exist and have TemplateData.
      #
      # @return [self]
      def doNotIgnoreMissingTitles()
        merge(doNotIgnoreMissingTitles: 'true')
      end

      # Return localized values in this language. By default all available translations are returned.
      #
      # @param value [String]
      # @return [self]
      def lang(value)
        merge(lang: value.to_s)
      end
    end
  end
end
