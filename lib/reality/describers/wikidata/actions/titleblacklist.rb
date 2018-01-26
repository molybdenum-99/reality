# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Validate an article title, filename, or username against the TitleBlacklist.
    #
    # Usage:
    #
    # ```ruby
    # api.titleblacklist.title(value).perform # returns string with raw output
    # # or
    # api.titleblacklist.title(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Titleblacklist < Reality::Describers::Wikidata::Impl::Actions::Get

      # The string to validate against the blacklist.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(tbtitle: value.to_s)
      end

      # The action to be checked.
      #
      # @param value [String] One of "create", "edit", "upload", "createtalk", "createpage", "move", "new-account".
      # @return [self]
      def action(value)
        _action(value) or fail ArgumentError, "Unknown value for action: #{value}"
      end

      # @private
      def _action(value)
        defined?(super) && super || ["create", "edit", "upload", "createtalk", "createpage", "move", "new-account"].include?(value.to_s) && merge(tbaction: value.to_s)
      end

      # Don't try to override the titleblacklist.
      #
      # @return [self]
      def nooverride()
        merge(tbnooverride: 'true')
      end
    end
  end
end
