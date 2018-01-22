# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Deprecated in favor of action=flow&submodule=lock-topic.
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
    module CloseOpenTopic

      # State to put topic in, either "lock" or "unlock".
      #
      # @param value [String] One of "lock", "unlock", "close", "reopen".
      # @return [self]
      def moderationState(value)
        _moderationState(value) or fail ArgumentError, "Unknown value for moderationState: #{value}"
      end

      # @private
      def _moderationState(value)
        defined?(super) && super || ["lock", "unlock", "close", "reopen"].include?(value.to_s) && merge(cotmoderationState: value.to_s)
      end

      # Reason for locking or unlocking the topic.
      #
      # @param value [String]
      # @return [self]
      def reason(value)
        merge(cotreason: value.to_s)
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
