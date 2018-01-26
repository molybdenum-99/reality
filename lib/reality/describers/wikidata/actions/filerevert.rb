# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Revert a file to an old version.
    #
    # Usage:
    #
    # ```ruby
    # api.filerevert.filename(value).perform # returns string with raw output
    # # or
    # api.filerevert.filename(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Filerevert < Reality::Describers::Wikidata::Impl::Actions::Post

      # Target filename, without the File: prefix.
      #
      # @param value [String]
      # @return [self]
      def filename(value)
        merge(filename: value.to_s)
      end

      # Upload comment.
      #
      # @param value [String]
      # @return [self]
      def comment(value)
        merge(comment: value.to_s)
      end

      # Archive name of the revision to revert to.
      #
      # @param value [String]
      # @return [self]
      def archivename(value)
        merge(archivename: value.to_s)
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
