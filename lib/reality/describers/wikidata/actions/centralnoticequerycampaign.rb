# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Get all configuration settings for a campaign.
    #
    # Usage:
    #
    # ```ruby
    # api.centralnoticequerycampaign.campaign(value).perform # returns string with raw output
    # # or
    # api.centralnoticequerycampaign.campaign(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Centralnoticequerycampaign < Reality::Describers::Wikidata::Impl::Actions::Get

      # Campaign name. Separate multiple values with a "|" (vertical bar).
      #
      # @param value [String]
      # @return [self]
      def campaign(value)
        merge(campaign: value.to_s)
      end
    end
  end
end
