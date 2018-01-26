# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Output data in XML format.
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
    module Xml

      # If specified, adds the named page as an XSL stylesheet. The value must be a title in the MediaWiki namespace ending in .xsl.
      #
      # @param value [String]
      # @return [self]
      def xslt(value)
        merge(xslt: value.to_s)
      end

      # If specified, adds an XML namespace.
      #
      # @return [self]
      def includexmlnamespace()
        merge(includexmlnamespace: 'true')
      end
    end
  end
end
