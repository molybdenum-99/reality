# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Returns HTML5 for a page from the Parsoid service.
    #
    # Usage:
    #
    # ```ruby
    # api.visualeditor.page(value).perform # returns string with raw output
    # # or
    # api.visualeditor.page(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Visualeditor < Reality::Describers::Wikidata::Impl::Actions::Get

      # The page to perform actions on.
      #
      # @param value [String]
      # @return [self]
      def page(value)
        merge(page: value.to_s)
      end

      # 
      #
      # @param value [String] One of "json", "jsonfm".
      # @return [self]
      def format(value)
        _format(value) or fail ArgumentError, "Unknown value for format: #{value}"
      end

      # @private
      def _format(value)
        defined?(super) && super || ["json", "jsonfm"].include?(value.to_s) && merge(format: value.to_s)
      end

      # Action to perform.
      #
      # @param value [String] One of "parse", "metadata", "wikitext", "parsefragment", "getlanglinks".
      # @return [self]
      def paction(value)
        _paction(value) or fail ArgumentError, "Unknown value for paction: #{value}"
      end

      # @private
      def _paction(value)
        defined?(super) && super || ["parse", "metadata", "wikitext", "parsefragment", "getlanglinks"].include?(value.to_s) && merge(paction: value.to_s)
      end

      # Wikitext to send to Parsoid to convert to HTML (paction=parsefragment).
      #
      # @param value [String]
      # @return [self]
      def wikitext(value)
        merge(wikitext: value.to_s)
      end

      # The section on which to act.
      #
      # @param value [String]
      # @return [self]
      def section(value)
        merge(section: value.to_s)
      end

      # The revision number to use (defaults to latest revision).
      #
      # @param value [String]
      # @return [self]
      def oldid(value)
        merge(oldid: value.to_s)
      end

      # Edit intro to add to notices.
      #
      # @param value [String]
      # @return [self]
      def editintro(value)
        merge(editintro: value.to_s)
      end

      # Pre-save transform wikitext before sending it to Parsoid (paction=parsefragment).
      #
      # @return [self]
      def pst()
        merge(pst: 'true')
      end
    end
  end
end
