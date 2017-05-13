# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Query all translations aids.
    #
    # Usage:
    #
    # ```ruby
    # api.translationaids.title(value).perform # returns string with raw output
    # # or
    # api.translationaids.title(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Translationaids < Reality::DataSources::Wikidata::Impl::Actions::Get

      # Full title of a known message.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(title: value.to_s)
      end

      # Message group the message belongs to. If empty then primary group is used.
      #
      # @param value [String]
      # @return [self]
      def group(value)
        merge(group: value.to_s)
      end

      # Which translation helpers to include.
      #
      # @param values [Array<String>] Allowed values: "definition", "translation", "inotherlanguages", "documentation", "mt", "definitiondiff", "ttmserver", "support", "gettext", "insertables".
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["definition", "translation", "inotherlanguages", "documentation", "mt", "definitiondiff", "ttmserver", "support", "gettext", "insertables"].include?(value.to_s) && merge(prop: value.to_s, replace: false)
      end
    end
  end
end
