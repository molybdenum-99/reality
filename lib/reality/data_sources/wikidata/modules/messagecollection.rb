# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Query MessageCollection about translations.
    #
    # The "submodule" (MediaWiki API term) is included in action after setting some param, providing
    # additional tweaking for this param. Example (for {Reality::DataSources::Wikidata::Impl::Actions::Query} and
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
    module Messagecollection

      # Message group.
      #
      # @param value [String]
      # @return [self]
      def group(value)
        merge(mcgroup: value.to_s)
      end

      # Language code.
      #
      # @param value [String]
      # @return [self]
      def language(value)
        merge(mclanguage: value.to_s)
      end

      # How many messages to show (after filtering).
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(mclimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def offset(value)
        merge(mcoffset: value.to_s)
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
        defined?(super) && super || ["fuzzy", "optional", "ignored", "hastranslation", "translated", "changed", "reviewer:N", "last-translator:N"].include?(value.to_s) && merge(mcfilter: value.to_s, replace: false)
      end

      # Which properties to get:
      #
      # @param values [Array<String>] Allowed values: "definition" (Message definition), "translation" (Current translation (without !!FUZZY!! string if any, use the tags to check for outdated or broken translations)), "tags" (Message tags, like optional, ignored and fuzzy), "properties" (Message properties, like status, revision, last-translator. Can vary between messages), "revision" (Deprecated! Use mcprop=properties).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["definition", "translation", "tags", "properties", "revision"].include?(value.to_s) && merge(mcprop: value.to_s, replace: false)
      end
    end
  end
end
