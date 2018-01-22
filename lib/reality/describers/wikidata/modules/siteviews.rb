# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Shows sitewide pageview data (daily pageview totals for each of the last pvisdays days). The result format is date (Ymd) => count.
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
    module Siteviews

      # The metric to use for counting views. Depending on what backend is used, not all metrics might be supported. You can use the siteinfo API (action=query&meta=siteinfo) to check, under pageviewservice-supported-metrics / <module name>
      #
      # @param value [String] One of "pageviews" (Plain pageviews), "uniques" (Unique visitors).
      # @return [self]
      def metric(value)
        _metric(value) or fail ArgumentError, "Unknown value for metric: #{value}"
      end

      # @private
      def _metric(value)
        defined?(super) && super || ["pageviews", "uniques"].include?(value.to_s) && merge(pvismetric: value.to_s)
      end

      # The number of days to show.
      #
      # @param value [Integer]
      # @return [self]
      def days(value)
        merge(pvisdays: value.to_s)
      end
    end
  end
end
