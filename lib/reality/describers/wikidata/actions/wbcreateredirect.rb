# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Creates Entity redirects.
    #
    # Usage:
    #
    # ```ruby
    # api.wbcreateredirect.from(value).perform # returns string with raw output
    # # or
    # api.wbcreateredirect.from(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Wbcreateredirect < Reality::DataSources::Wikidata::Impl::Actions::Post

      # Entity ID to make a redirect
      #
      # @param value [String]
      # @return [self]
      def from(value)
        merge(from: value.to_s)
      end

      # Entity ID to point the redirect to
      #
      # @param value [String]
      # @return [self]
      def to(value)
        merge(to: value.to_s)
      end

      # A "csrf" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end

      # Mark this edit as bot. This URL flag will only be respected if the user belongs to the group "Bots".
      #
      # @return [self]
      def bot()
        merge(bot: 'true')
      end
    end
  end
end
