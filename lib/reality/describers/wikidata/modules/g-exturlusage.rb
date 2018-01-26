# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Enumerate pages that contain a given URL. _Generator module: for fetching pages corresponding to request._
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
    module GExturlusage

      # When more results are available, use this to continue.
      #
      # @param value [Integer]
      # @return [self]
      def offset(value)
        merge(geuoffset: value.to_s)
      end

      # Protocol of the URL. If empty and euquery is set, the protocol is http. Leave both this and euquery empty to list all external links.
      #
      # @param value [String] One of "bitcoin", "ftp", "ftps", "geo", "git", "gopher", "http", "https", "irc", "ircs", "magnet", "mailto", "mms", "news", "nntp", "redis", "sftp", "sip", "sips", "sms", "ssh", "svn", "tel", "telnet", "urn", "worldwind", "xmpp".
      # @return [self]
      def protocol(value)
        _protocol(value) or fail ArgumentError, "Unknown value for protocol: #{value}"
      end

      # @private
      def _protocol(value)
        defined?(super) && super || ["bitcoin", "ftp", "ftps", "geo", "git", "gopher", "http", "https", "irc", "ircs", "magnet", "mailto", "mms", "news", "nntp", "redis", "sftp", "sip", "sips", "sms", "ssh", "svn", "tel", "telnet", "urn", "worldwind", "xmpp"].include?(value.to_s) && merge(geuprotocol: value.to_s)
      end

      # Search string without protocol. See Special:LinkSearch. Leave empty to list all external links.
      #
      # @param value [String]
      # @return [self]
      def query(value)
        merge(geuquery: value.to_s)
      end

      # The page namespaces to enumerate.
      #
      # @param values [Array<String>] Allowed values: "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600".
      # @return [self]
      def namespace(*values)
        values.inject(self) { |res, val| res._namespace(val) or fail ArgumentError, "Unknown value for namespace: #{val}" }
      end

      # @private
      def _namespace(value)
        defined?(super) && super || ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "120", "121", "122", "123", "828", "829", "1198", "1199", "2300", "2301", "2302", "2303", "2600"].include?(value.to_s) && merge(geunamespace: value.to_s, replace: false)
      end

      # How many pages to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(geulimit: value.to_s)
      end

      # Expand protocol-relative URLs with the canonical protocol.
      #
      # @return [self]
      def expandurl()
        merge(geuexpandurl: 'true')
      end
    end
  end
end
