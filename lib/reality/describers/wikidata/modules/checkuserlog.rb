# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Get entries from the CheckUser log.
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
    module Checkuserlog

      # Username of the CheckUser.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(culuser: value.to_s)
      end

      # Checked user, IP address, or CIDR range.
      #
      # @param value [String]
      # @return [self]
      def target(value)
        merge(cultarget: value.to_s)
      end

      # Limit of rows.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(cullimit: value.to_s)
      end

      # In which direction to enumerate:
      #
      # @param value [String] One of "newer" (List oldest first. Note: culstart has to be before culend), "older" (List newest first (default). Note: culstart has to be later than culend).
      # @return [self]
      def dir(value)
        _dir(value) or fail ArgumentError, "Unknown value for dir: #{value}"
      end

      # @private
      def _dir(value)
        defined?(super) && super || ["newer", "older"].include?(value.to_s) && merge(culdir: value.to_s)
      end

      # The timestamp to start enumerating from.
      #
      # @param value [Time]
      # @return [self]
      def from(value)
        merge(culfrom: value.iso8601)
      end

      # The timestamp to end enumerating.
      #
      # @param value [Time]
      # @return [self]
      def to(value)
        merge(culto: value.iso8601)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(culcontinue: value.to_s)
      end
    end
  end
end
