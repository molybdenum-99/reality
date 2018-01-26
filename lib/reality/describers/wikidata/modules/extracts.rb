# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Returns plain-text or limited HTML extracts of the given pages.
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
    module Extracts

      # How many characters to return. Actual text returned might be slightly longer.
      #
      # @param value [Integer]
      # @return [self]
      def chars(value)
        merge(exchars: value.to_s)
      end

      # How many sentences to return.
      #
      # @param value [Integer]
      # @return [self]
      def sentences(value)
        merge(exsentences: value.to_s)
      end

      # How many extracts to return. (Multiple extracts can only be returned if exintro is set to true.)
      #
      # @param value [Integer, "max"]
      # @return [self]
      def limit(value)
        merge(exlimit: value.to_s)
      end

      # Return only content before the first section.
      #
      # @return [self]
      def intro()
        merge(exintro: 'true')
      end

      # Return extracts as plain text instead of limited HTML.
      #
      # @return [self]
      def plaintext()
        merge(explaintext: 'true')
      end

      # How to format sections in plaintext mode:
      #
      # @param value [String] One of "plain" (No formatting), "wiki" (Wikitext-style formatting (== like this ==)), "raw" (This module's internal representation (section titles prefixed with <ASCII 1><ASCII 2><section level><ASCII 2><ASCII 1>)).
      # @return [self]
      def sectionformat(value)
        _sectionformat(value) or fail ArgumentError, "Unknown value for sectionformat: #{value}"
      end

      # @private
      def _sectionformat(value)
        defined?(super) && super || ["plain", "wiki", "raw"].include?(value.to_s) && merge(exsectionformat: value.to_s)
      end

      # When more results are available, use this to continue.
      #
      # @param value [Integer]
      # @return [self]
      def continue(value)
        merge(excontinue: value.to_s)
      end
    end
  end
end
