# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Set a global user's status.
    #
    # Usage:
    #
    # ```ruby
    # api.setglobalaccountstatus.user(value).perform # returns string with raw output
    # # or
    # api.setglobalaccountstatus.user(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Setglobalaccountstatus < Reality::DataSources::Wikidata::Impl::Actions::Post

      # User to change the status of.
      #
      # @param value [String]
      # @return [self]
      def user(value)
        merge(user: value.to_s)
      end

      # Change whether this user is locked or not.
      #
      # @param value [String] One of "lock", "unlock".
      # @return [self]
      def locked(value)
        _locked(value) or fail ArgumentError, "Unknown value for locked: #{value}"
      end

      # @private
      def _locked(value)
        defined?(super) && super || ["lock", "unlock"].include?(value.to_s) && merge(locked: value.to_s)
      end

      # Change whether this user is not hidden, hidden from lists, or suppressed.
      #
      # @param value [String] One of "lists", "suppressed".
      # @return [self]
      def hidden(value)
        _hidden(value) or fail ArgumentError, "Unknown value for hidden: #{value}"
      end

      # @private
      def _hidden(value)
        defined?(super) && super || ["lists", "suppressed"].include?(value.to_s) && merge(hidden: value.to_s)
      end

      # Reason for changing the user's status.
      #
      # @param value [String]
      # @return [self]
      def reason(value)
        merge(reason: value.to_s)
      end

      # Optional MD5 of the expected current <username>:<hidden>:<locked>, to detect edit conflicts. Set <locked> to 1 for locked, 0 for unlocked.
      #
      # @param value [String]
      # @return [self]
      def statecheck(value)
        merge(statecheck: value.to_s)
      end

      # A "setglobalaccountstatus" token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end
    end
  end
end
