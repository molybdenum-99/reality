# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Query MessageCollection about translations. _Generator module: for fetching pages corresponding to request._
    #
    # The "submodule" (MediaWiki API term) is included in action after setting some param, providing
    # additional tweaking for this param. Example (for {Reality::Describers::Wikidata::Impl::Actions::Query} and
    # its submodules):
    #
    # ```ruby
    # api.query             # returns Actions::Query
    #    .prop(:revisions)  # adds prop=revisions to action URL, and includes Modules::Revisions into action
    #    .limit(10)         # method of Modules::Revisions, adds rvlimit=10 to URL
    # ```
    #
    # All submodule's parameters are documented as its public methods, see below.
    #
    module GMessagecollection

      # Message group.
      #
      # @param value [String]
      # @return [self]
      def group(value)
        merge(gmcgroup: value.to_s)
      end

      # Language code.
      #
      # @param value [String]
      # @return [self]
      def language(value)
        merge(gmclanguage: value.to_s)
      end

      # How many messages to show (after filtering).
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(gmclimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def offset(value)
        merge(gmcoffset: value.to_s)
      end

      # Message collection filters. Use ! to negate condition. For example !fuzzy means list only all non-fuzzy messages. Filters are applied in the order given.
      #
      # @param values [Array<String>] Allowed values: "fuzzy" (Messages with fuzzy tag), "optional" (Messages which should be translated only if changes are necessary), "ignored" (Messages which are never translated), "hastranslation" (Messages which have a translation regardless if it is fuzzy or not), "translated" (Messages which have a translation which is not fuzzy), "changed" (Messages which have been translated or changed since last export), "reviewer:N" (Messages where the user number N is among reviewers), "last-translator:N" (Messages where the user number N is the last translator).
      # @return [self]
      def filter(*values)
        values.inject(self) { |res, val| res._filter(val) or fail ArgumentError, "Unknown value for filter: #{val}" }
      end

      # @private
      def _filter(value)
        defined?(super) && super || ["fuzzy", "optional", "ignored", "hastranslation", "translated", "changed", "reviewer:N", "last-translator:N"].include?(value.to_s) && merge(gmcfilter: value.to_s, replace: false)
      end
    end
  end
end
