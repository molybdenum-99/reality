# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Actions
    # Delete and undelete revisions.
    #
    # Usage:
    #
    # ```ruby
    # api.revisiondelete.type(value).perform # returns string with raw output
    # # or
    # api.revisiondelete.type(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::Describers::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Revisiondelete < Reality::Describers::Wikidata::Impl::Actions::Post

      # Type of revision deletion being performed.
      #
      # @param value [String] One of "revision", "archive", "oldimage", "filearchive", "logging".
      # @return [self]
      def type(value)
        _type(value) or fail ArgumentError, "Unknown value for type: #{value}"
      end

      # @private
      def _type(value)
        defined?(super) && super || ["revision", "archive", "oldimage", "filearchive", "logging"].include?(value.to_s) && merge(type: value.to_s)
      end

      # Page title for the revision deletion, if required for the type.
      #
      # @param value [String]
      # @return [self]
      def target(value)
        merge(target: value.to_s)
      end

      # Identifiers for the revisions to be deleted.
      #
      # @param values [Array<String>]
      # @return [self]
      def ids(*values)
        values.inject(self) { |res, val| res._ids(val) }
      end

      # @private
      def _ids(value)
        merge(ids: value.to_s, replace: false)
      end

      # What to hide for each revision.
      #
      # @param values [Array<String>] Allowed values: "content", "comment", "user".
      # @return [self]
      def hide(*values)
        values.inject(self) { |res, val| res._hide(val) or fail ArgumentError, "Unknown value for hide: #{val}" }
      end

      # @private
      def _hide(value)
        defined?(super) && super || ["content", "comment", "user"].include?(value.to_s) && merge(hide: value.to_s, replace: false)
      end

      # What to unhide for each revision.
      #
      # @param values [Array<String>] Allowed values: "content", "comment", "user".
      # @return [self]
      def show(*values)
        values.inject(self) { |res, val| res._show(val) or fail ArgumentError, "Unknown value for show: #{val}" }
      end

      # @private
      def _show(value)
        defined?(super) && super || ["content", "comment", "user"].include?(value.to_s) && merge(show: value.to_s, replace: false)
      end

      # Whether to suppress data from administrators as well as others.
      #
      # @param value [String] One of "yes", "no", "nochange".
      # @return [self]
      def suppress(value)
        _suppress(value) or fail ArgumentError, "Unknown value for suppress: #{value}"
      end

      # @private
      def _suppress(value)
        defined?(super) && super || ["yes", "no", "nochange"].include?(value.to_s) && merge(suppress: value.to_s)
      end

      # Reason for the deletion or undeletion.
      #
      # @param value [String]
      # @return [self]
      def reason(value)
        merge(reason: value.to_s)
      end

      # Tags to apply to the entry in the deletion log.
      #
      # @param values [Array<String>] Allowed values: "InfoboxExport gadget", "WE-Framework gadget".
      # @return [self]
      def tags(*values)
        values.inject(self) { |res, val| res._tags(val) or fail ArgumentError, "Unknown value for tags: #{val}" }
      end

      # @private
      def _tags(value)
        defined?(super) && super || ["InfoboxExport gadget", "WE-Framework gadget"].include?(value.to_s) && merge(tags: value.to_s, replace: false)
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
