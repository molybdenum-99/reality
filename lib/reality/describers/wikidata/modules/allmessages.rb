# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Return messages from this site.
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
    module Allmessages

      # Which messages to output. * (default) means all messages.
      #
      # @param values [Array<String>]
      # @return [self]
      def messages(*values)
        values.inject(self) { |res, val| res._messages(val) }
      end

      # @private
      def _messages(value)
        merge(ammessages: value.to_s, replace: false)
      end

      # Which properties to get.
      #
      # @param values [Array<String>] Allowed values: "default".
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["default"].include?(value.to_s) && merge(amprop: value.to_s, replace: false)
      end

      # Set to enable parser, will preprocess the wikitext of message (substitute magic words, handle templates, etc.).
      #
      # @return [self]
      def enableparser()
        merge(amenableparser: 'true')
      end

      # If set, do not include the content of the messages in the output.
      #
      # @return [self]
      def nocontent()
        merge(amnocontent: 'true')
      end

      # Also include local messages, i.e. messages that don't exist in the software but do exist as in the MediaWiki namespace. This lists all MediaWiki-namespace pages, so it will also list those that aren't really messages such as Common.js.
      #
      # @return [self]
      def includelocal()
        merge(amincludelocal: 'true')
      end

      # Arguments to be substituted into message.
      #
      # @param values [Array<String>]
      # @return [self]
      def args(*values)
        values.inject(self) { |res, val| res._args(val) }
      end

      # @private
      def _args(value)
        merge(amargs: value.to_s, replace: false)
      end

      # Return only messages with names that contain this string.
      #
      # @param value [String]
      # @return [self]
      def filter(value)
        merge(amfilter: value.to_s)
      end

      # Return only messages in this customisation state.
      #
      # @param value [String] One of "all", "modified", "unmodified".
      # @return [self]
      def customised(value)
        _customised(value) or fail ArgumentError, "Unknown value for customised: #{value}"
      end

      # @private
      def _customised(value)
        defined?(super) && super || ["all", "modified", "unmodified"].include?(value.to_s) && merge(amcustomised: value.to_s)
      end

      # Return messages in this language.
      #
      # @param value [String]
      # @return [self]
      def lang(value)
        merge(amlang: value.to_s)
      end

      # Return messages starting at this message.
      #
      # @param value [String]
      # @return [self]
      def from(value)
        merge(amfrom: value.to_s)
      end

      # Return messages ending at this message.
      #
      # @param value [String]
      # @return [self]
      def to(value)
        merge(amto: value.to_s)
      end

      # Page name to use as context when parsing message (for amenableparser option).
      #
      # @param value [String]
      # @return [self]
      def title(value)
        merge(amtitle: value.to_s)
      end

      # Return messages with this prefix.
      #
      # @param value [String]
      # @return [self]
      def prefix(value)
        merge(amprefix: value.to_s)
      end
    end
  end
end
