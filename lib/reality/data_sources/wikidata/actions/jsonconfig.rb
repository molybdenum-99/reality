# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Allows direct access to JsonConfig subsystem.
    #
    # Usage:
    #
    # ```ruby
    # api.jsonconfig.command(value).perform # returns string with raw output
    # # or
    # api.jsonconfig.command(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Jsonconfig < Reality::DataSources::Wikidata::Impl::Actions::Get

      # Which sub-action to perform on JsonConfig:
      #
      # @param value [String] One of "status" (Shows JsonConfig configuration), "reset" (Clears configurations from cache. Requires title parameter and jsonconfig-reset right), "reload" (Reloads and caches configurations from config store. Requires title parameter and jsonconfig-reset right).
      # @return [self]
      def command(value)
        _command(value) or fail ArgumentError, "Unknown value for command: #{value}"
      end

      # @private
      def _command(value)
        defined?(super) && super || ["status", "reset", "reload"].include?(value.to_s) && merge(command: value.to_s)
      end

      # Namespace number of the title to process.
      #
      # @param value [Integer]
      # @return [self]
      def namespace(value)
        merge(namespace: value.to_s)
      end

      # Title to process without namespace prefix.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(title: value.to_s)
      end

      # For command=reload, use this content instead.
      #
      # @param value [String]
      # @return [self]
      def content(value)
        merge(content: value.to_s)
      end
    end
  end
end
