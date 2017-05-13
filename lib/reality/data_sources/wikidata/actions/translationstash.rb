# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Add translations to stash.
    #
    # Usage:
    #
    # ```ruby
    # api.translationstash.subaction(value).perform # returns string with raw output
    # # or
    # api.translationstash.subaction(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Translationstash < Reality::DataSources::Wikidata::Impl::Actions::Post

      # Action.
      #
      # @param value [String] One of "add", "query".
      # @return [self]
      def subaction(value)
        _subaction(value) or fail ArgumentError, "Unknown value for subaction: #{value}"
      end

      # @private
      def _subaction(value)
        defined?(super) && super || ["add", "query"].include?(value.to_s) && merge(subaction: value.to_s)
      end

      # Title of the translation unit page.
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(title: value.to_s)
      end

      # Translation made by the user.
      #
      # @param value [String]
      # @return [self]
      def translation(value)
        merge(translation: value.to_s)
      end

      # JSON object.
      #
      # @param value [String]
      # @return [self]
      def metadata(value)
        merge(metadata: value.to_s)
      end

      # A "csrf" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end

      # Optionally the user whose stash to get. Only privileged users can do this.
      #
      # @param value [String]
      # @return [self]
      def username(value)
        merge(username: value.to_s)
      end
    end
  end
end
