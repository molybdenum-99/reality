# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Get Wikimedia sites list.
    #
    # Usage:
    #
    # ```ruby
    # api.sitematrix.type(value).perform # returns string with raw output
    # # or
    # api.sitematrix.type(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Sitematrix < Reality::Describers::Wikidata::Impl::Actions::Get

      # Filter the Site Matrix by type:
      #
      # @param values [Array<String>] Allowed values: "special" (One off and multilingual Wikimedia projects), "language" (Wikimedia projects under this language code).
      # @return [self]
      def type(*values)
        values.inject(self) { |res, val| res._type(val) or fail ArgumentError, "Unknown value for type: #{val}" }
      end

      # @private
      def _type(value)
        defined?(super) && super || ["special", "language"].include?(value.to_s) && merge(smtype: value.to_s, replace: false)
      end

      # Filter the Site Matrix by wiki state:
      #
      # @param values [Array<String>] Allowed values: "all", "closed", "private", "fishbowl", "nonglobal".
      # @return [self]
      def state(*values)
        values.inject(self) { |res, val| res._state(val) or fail ArgumentError, "Unknown value for state: #{val}" }
      end

      # @private
      def _state(value)
        defined?(super) && super || ["all", "closed", "private", "fishbowl", "nonglobal"].include?(value.to_s) && merge(smstate: value.to_s, replace: false)
      end

      # Which information about a language to return.
      #
      # @param values [Array<String>] Allowed values: "code", "name", "site", "localname".
      # @return [self]
      def langprop(*values)
        values.inject(self) { |res, val| res._langprop(val) or fail ArgumentError, "Unknown value for langprop: #{val}" }
      end

      # @private
      def _langprop(value)
        defined?(super) && super || ["code", "name", "site", "localname"].include?(value.to_s) && merge(smlangprop: value.to_s, replace: false)
      end

      # Which information about a site to return.
      #
      # @param values [Array<String>] Allowed values: "url", "dbname", "code", "sitename".
      # @return [self]
      def siteprop(*values)
        values.inject(self) { |res, val| res._siteprop(val) or fail ArgumentError, "Unknown value for siteprop: #{val}" }
      end

      # @private
      def _siteprop(value)
        defined?(super) && super || ["url", "dbname", "code", "sitename"].include?(value.to_s) && merge(smsiteprop: value.to_s, replace: false)
      end

      # Maximum number of results.
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(smlimit: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [String]
      # @return [self]
      def continue(value)
        merge(smcontinue: value.to_s)
      end
    end
  end
end
