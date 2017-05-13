# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Modules
    # Returns all external URLs (not interwikis) from the given pages.
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
    module Extlinks

      # How many links to return.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(ellimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [Integer]
      # @return [self]
      def offset(value)
        merge(eloffset: value.to_s)
      end

      # Protocol of the URL. If empty and elquery is set, the protocol is http. Leave both this and elquery empty to list all external links.
      #
      # @param value [String] One of "bitcoin", "ftp", "ftps", "geo", "git", "gopher", "http", "https", "irc", "ircs", "magnet", "mailto", "mms", "news", "nntp", "redis", "sftp", "sip", "sips", "sms", "ssh", "svn", "tel", "telnet", "urn", "worldwind", "xmpp".
      # @return [self]
      def protocol(value)
        _protocol(value) or fail ArgumentError, "Unknown value for protocol: #{value}"
      end

      # @private
      def _protocol(value)
        defined?(super) && super || ["bitcoin", "ftp", "ftps", "geo", "git", "gopher", "http", "https", "irc", "ircs", "magnet", "mailto", "mms", "news", "nntp", "redis", "sftp", "sip", "sips", "sms", "ssh", "svn", "tel", "telnet", "urn", "worldwind", "xmpp"].include?(value.to_s) && merge(elprotocol: value.to_s)
      end

      # Search string without protocol. Useful for checking whether a certain page contains a certain external url.
      #
      # @param value [String]
      # @return [self]
      def query(value)
        merge(elquery: value.to_s)
      end

      # Expand protocol-relative URLs with the canonical protocol.
      #
      # @return [self]
      def expandurl()
        merge(elexpandurl: 'true')
      end
    end
  end
end
