# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Retrieve information about the current authentication status.
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
    module Authmanagerinfo

      # Test whether the user's current authentication status is sufficient for the specified security-sensitive operation.
      #
      # @param value [String]
      # @return [self]
      def securitysensitiveoperation(value)
        merge(amisecuritysensitiveoperation: value.to_s)
      end

      # Fetch information about the authentication requests needed for the specified authentication action.
      #
      # @param value [String] One of "login", "login-continue", "create", "create-continue", "link", "link-continue", "change", "remove", "unlink".
      # @return [self]
      def requestsfor(value)
        _requestsfor(value) or fail ArgumentError, "Unknown value for requestsfor: #{value}"
      end

      # @private
      def _requestsfor(value)
        defined?(super) && super || ["login", "login-continue", "create", "create-continue", "link", "link-continue", "change", "remove", "unlink"].include?(value.to_s) && merge(amirequestsfor: value.to_s)
      end

      # Merge field information for all authentication requests into one array.
      #
      # @return [self]
      def mergerequestfields()
        merge(amimergerequestfields: 'true')
      end

      # Format to use for returning messages.
      #
      # @param value [String] One of "html", "wikitext", "raw", "none".
      # @return [self]
      def messageformat(value)
        _messageformat(value) or fail ArgumentError, "Unknown value for messageformat: #{value}"
      end

      # @private
      def _messageformat(value)
        defined?(super) && super || ["html", "wikitext", "raw", "none"].include?(value.to_s) && merge(amimessageformat: value.to_s)
      end
    end
  end
end
