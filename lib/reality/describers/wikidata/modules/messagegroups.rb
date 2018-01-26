# frozen_string_literal: true

module Reality::Describers::Wikidata::Impl
  module Modules
    # Return information about message groups.
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
    module Messagegroups

      # When using the tree format, limit the depth to this many levels. Value 0 means that no subgroups are shown. If the limit is reached, the output includes a "groupcount" value, which states the number of direct children.
      #
      # @param value [Integer]
      # @return [self]
      def depth(value)
        merge(mgdepth: value.to_s)
      end

      # Only return messages with IDs that match one or more of the inputs given (case-insensitive, separated by pipes, * wildcard).
      #
      # @param values [Array<String>]
      # @return [self]
      def filter(*values)
        values.inject(self) { |res, val| res._filter(val) }
      end

      # @private
      def _filter(value)
        merge(mgfilter: value.to_s, replace: false)
      end

      # In the tree format message groups can exist in multiple places in the tree.
      #
      # @param value [String] One of "flat", "tree".
      # @return [self]
      def format(value)
        _format(value) or fail ArgumentError, "Unknown value for format: #{value}"
      end

      # @private
      def _format(value)
        defined?(super) && super || ["flat", "tree"].include?(value.to_s) && merge(mgformat: value.to_s)
      end

      # Preferred size of rasterised group icon.
      #
      # @param value [Integer]
      # @return [self]
      def iconsize(value)
        merge(mgiconsize: value.to_s)
      end

      # What translation-related information to get:
      #
      # @param values [Array<String>] Allowed values: "id" (Include ID of the group), "label" (Include label of the group), "description" (Include description of the group), "class" (Include class name of the group), "namespace" (Include namespace of the group. Not all groups belong to a single namespace), "exists" (Include self-calculated existence property of the group), "icon" (Include URLs to icon of the group), "priority" (Include priority status like discouraged), "prioritylangs" (Include preferred languages. If not set, this returns false), "priorityforce" (Include priority status - is the priority languages setting forced), "workflowstates" (Include the workflow states for the message group).
      # @return [self]
      def prop(*values)
        values.inject(self) { |res, val| res._prop(val) or fail ArgumentError, "Unknown value for prop: #{val}" }
      end

      # @private
      def _prop(value)
        defined?(super) && super || ["id", "label", "description", "class", "namespace", "exists", "icon", "priority", "prioritylangs", "priorityforce", "workflowstates"].include?(value.to_s) && merge(mgprop: value.to_s, replace: false)
      end

      # When using the tree format, instead of starting from top level start from the given message group, which must be an aggregate message group. When using flat format only the specified group is returned.
      #
      # @param value [String]
      # @return [self]
      def root(value)
        merge(mgroot: value.to_s)
      end
    end
  end
end
