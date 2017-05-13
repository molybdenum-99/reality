# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Manage aggregate message groups.
    #
    # Usage:
    #
    # ```ruby
    # api.aggregategroups.do(value).perform # returns string with raw output
    # # or
    # api.aggregategroups.do(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Aggregategroups < Reality::DataSources::Wikidata::Impl::Actions::Post

      # What to do with aggregate message group.
      #
      # @param value [String] One of "associate", "dissociate", "remove", "add", "update".
      # @return [self]
      def do(value)
        _do(value) or fail ArgumentError, "Unknown value for do: #{value}"
      end

      # @private
      def _do(value)
        defined?(super) && super || ["associate", "dissociate", "remove", "add", "update"].include?(value.to_s) && merge(do: value.to_s)
      end

      # Aggregate message group ID.
      #
      # @param value [String]
      # @return [self]
      def aggregategroup(value)
        merge(aggregategroup: value.to_s)
      end

      # Message group ID.
      #
      # @param value [String]
      # @return [self]
      def group(value)
        merge(group: value.to_s)
      end

      # Aggregate message group name.
      #
      # @param value [String]
      # @return [self]
      def groupname(value)
        merge(groupname: value.to_s)
      end

      # Aggregate message group description.
      #
      # @param value [String]
      # @return [self]
      def groupdescription(value)
        merge(groupdescription: value.to_s)
      end

      # A "csrf" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end
    end
  end
end
