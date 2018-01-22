# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Check which IP addresses are used by a given username or which usernames are used by a given IP address.
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
    module Checkuser

      # Type of CheckUser request:
      #
      # @param value [String] One of "userips" (Get IP address of target user), "edits" (Get changes from target IP address or range), "ipusers" (Get users from target IP address or range).
      # @return [self]
      def request(value)
        _request(value) or fail ArgumentError, "Unknown value for request: #{value}"
      end

      # @private
      def _request(value)
        defined?(super) && super || ["userips", "edits", "ipusers"].include?(value.to_s) && merge(curequest: value.to_s)
      end

      # Username, IP address, or CIDR range to check.
      #
      # @param value [String]
      # @return [self]
      def target(value)
        merge(cutarget: value.to_s)
      end

      # Reason to check.
      #
      # @param value [String]
      # @return [self]
      def reason(value)
        merge(cureason: value.to_s)
      end

      # Limit of rows.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(culimit: value.to_s)
      end

      # Time limit of user data (like "-2 weeks" or "2 weeks ago").
      #
      # @param value [String]
      # @return [self]
      def timecond(value)
        merge(cutimecond: value.to_s)
      end

      # Use XFF data instead of IP address.
      #
      # @param value [String]
      # @return [self]
      def xff(value)
        merge(cuxff: value.to_s)
      end

      # A "csrf" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(cutoken: value.to_s)
      end
    end
  end
end
