# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Used by browsers to report violations of the Content Security Policy. This module should never be used, except when used automatically by a CSP compliant web browser.
    #
    # Usage:
    #
    # ```ruby
    # api.cspreport.reportonly(value).perform # returns string with raw output
    # # or
    # api.cspreport.reportonly(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Cspreport < Reality::Describers::Wikidata::Impl::Actions::Post

      # Mark as being a report from a monitoring policy, not an enforced policy
      #
      # @return [self]
      def reportonly()
        merge(reportonly: 'true')
      end

      # What generated the CSP header that triggered this report
      #
      # @param value [String]
      # @return [self]
      def source(value)
        merge(source: value.to_s)
      end
    end
  end
end
