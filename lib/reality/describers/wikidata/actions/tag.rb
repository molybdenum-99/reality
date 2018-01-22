# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Add or remove change tags from individual revisions or log entries.
    #
    # Usage:
    #
    # ```ruby
    # api.tag.rcid(value).perform # returns string with raw output
    # # or
    # api.tag.rcid(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Tag < Reality::DataSources::Wikidata::Impl::Actions::Post

      # One or more recent changes IDs from which to add or remove the tag.
      #
      # @param values [Array<Integer>]
      # @return [self]
      def rcid(*values)
        values.inject(self) { |res, val| res._rcid(val) }
      end

      # @private
      def _rcid(value)
        merge(rcid: value.to_s, replace: false)
      end

      # One or more revision IDs from which to add or remove the tag.
      #
      # @param values [Array<Integer>]
      # @return [self]
      def revid(*values)
        values.inject(self) { |res, val| res._revid(val) }
      end

      # @private
      def _revid(value)
        merge(revid: value.to_s, replace: false)
      end

      # One or more log entry IDs from which to add or remove the tag.
      #
      # @param values [Array<Integer>]
      # @return [self]
      def logid(*values)
        values.inject(self) { |res, val| res._logid(val) }
      end

      # @private
      def _logid(value)
        merge(logid: value.to_s, replace: false)
      end

      # Tags to add. Only manually defined tags can be added.
      #
      # @param values [Array<String>] Allowed values: "InfoboxExport gadget", "WE-Framework gadget".
      # @return [self]
      def add(*values)
        values.inject(self) { |res, val| res._add(val) or fail ArgumentError, "Unknown value for add: #{val}" }
      end

      # @private
      def _add(value)
        defined?(super) && super || ["InfoboxExport gadget", "WE-Framework gadget"].include?(value.to_s) && merge(add: value.to_s, replace: false)
      end

      # Tags to remove. Only tags that are either manually defined or completely undefined can be removed.
      #
      # @param values [Array<String>]
      # @return [self]
      def remove(*values)
        values.inject(self) { |res, val| res._remove(val) }
      end

      # @private
      def _remove(value)
        merge(remove: value.to_s, replace: false)
      end

      # Reason for the change.
      #
      # @param value [String]
      # @return [self]
      def reason(value)
        merge(reason: value.to_s)
      end

      # Tags to apply to the log entry that will be created as a result of this action.
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
