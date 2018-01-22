# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Get a summary of logged API feature usages for a user agent.
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
    module Featureusage

      # Start of date range to query.
      #
      # @param value [Time]
      # @return [self]
      def start(value)
        merge(afustart: value.iso8601)
      end

      # End of date range to query.
      #
      # @param value [Time]
      # @return [self]
      def end(value)
        merge(afuend: value.iso8601)
      end

      # User agent to query. If not specified, the agent in the request will be queried.
      #
      # @param value [String]
      # @return [self]
      def agent(value)
        merge(afuagent: value.to_s)
      end

      # If specified, return details on only these features.
      #
      # @param values [Array<String>]
      # @return [self]
      def features(*values)
        values.inject(self) { |res, val| res._features(val) }
      end

      # @private
      def _features(value)
        merge(afufeatures: value.to_s, replace: false)
      end
    end
  end
end
