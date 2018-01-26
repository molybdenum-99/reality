# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Users with the 'transcode-reset' right can reset and re-run a transcode job.
    #
    # Usage:
    #
    # ```ruby
    # api.transcodereset.title(value).perform # returns string with raw output
    # # or
    # api.transcodereset.title(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Transcodereset < Reality::Describers::Wikidata::Impl::Actions::Post

      # The media file title.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(title: value.to_s)
      end

      # The transcode key you wish to reset. Fetch from action=query&prop=transcodestatus.
      #
      # @param value [String]
      # @return [self]
      def transcodekey(value)
        merge(transcodekey: value.to_s)
      end

      # A "csrf" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end
    end
  end
end
