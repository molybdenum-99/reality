# frozen_string_literal: true

module Reality::DataSources::Wikidata::Impl
  module Actions
    # Allows actions to be taken on Flow pages.
    #
    # Usage:
    #
    # ```ruby
    # api.flow.submodule(value).perform # returns string with raw output
    # # or
    # api.flow.submodule(value).response # returns output parsed and wrapped into Response object
    # ```
    #
    # See {Base} for generic explanation of working with MediaWiki actions and
    # {Reality::DataSources::Wikidata::Impl::Response} for working with action responses.
    #
    # All action's parameters are documented as its public methods, see below.
    #
    class Flow < Reality::DataSources::Wikidata::Impl::Actions::Get

      # The Flow submodule to invoke.
      #
      # @param value [Symbol] Selecting an option includes tweaking methods from corresponding module:
      #   * `:close-open-topic` - {Reality::DataSources::Wikidata::Impl::Modules::CloseOpenTopic} Deprecated in favor of action=flow&submodule=lock-topic.
      #   * `:edit-header` - {Reality::DataSources::Wikidata::Impl::Modules::EditHeader} Edits a board description.
      #   * `:edit-post` - {Reality::DataSources::Wikidata::Impl::Modules::EditPost} Edits a post's content.
      #   * `:edit-title` - {Reality::DataSources::Wikidata::Impl::Modules::EditTitle} Edits a topic's title.
      #   * `:edit-topic-summary` - {Reality::DataSources::Wikidata::Impl::Modules::EditTopicSummary} Edits a topic summary's content.
      #   * `:lock-topic` - {Reality::DataSources::Wikidata::Impl::Modules::LockTopic} Lock or unlock a Flow topic.
      #   * `:moderate-post` - {Reality::DataSources::Wikidata::Impl::Modules::ModeratePost} Moderates a Flow post.
      #   * `:moderate-topic` - {Reality::DataSources::Wikidata::Impl::Modules::ModerateTopic} Moderates a Flow topic.
      #   * `:new-topic` - {Reality::DataSources::Wikidata::Impl::Modules::NewTopic} Creates a new Flow topic on the given workflow.
      #   * `:reply` - {Reality::DataSources::Wikidata::Impl::Modules::Reply} Replies to a post.
      #   * `:undo-edit-header` - {Reality::DataSources::Wikidata::Impl::Modules::UndoEditHeader} Retrieve information necessary to undo description edits.
      #   * `:undo-edit-post` - {Reality::DataSources::Wikidata::Impl::Modules::UndoEditPost} Retrieve information necesary to undo post edit.
      #   * `:undo-edit-topic-summary` - {Reality::DataSources::Wikidata::Impl::Modules::UndoEditTopicSummary} Retrieve information necessary to undo topic summary edits.
      #   * `:view-header` - {Reality::DataSources::Wikidata::Impl::Modules::ViewHeader} View a board description.
      #   * `:view-post` - {Reality::DataSources::Wikidata::Impl::Modules::ViewPost} View a post.
      #   * `:view-post-history` - {Reality::DataSources::Wikidata::Impl::Modules::ViewPostHistory} View the revision history of a post.
      #   * `:view-topic` - {Reality::DataSources::Wikidata::Impl::Modules::ViewTopic} View a topic.
      #   * `:view-topic-history` - {Reality::DataSources::Wikidata::Impl::Modules::ViewTopicHistory} View the revision history of a topic.
      #   * `:view-topic-summary` - {Reality::DataSources::Wikidata::Impl::Modules::ViewTopicSummary} View a topic summary.
      #   * `:view-topiclist` - {Reality::DataSources::Wikidata::Impl::Modules::ViewTopiclist} View a list of topics.
      # @return [self]
      def submodule(value)
        _submodule(value) or fail ArgumentError, "Unknown value for submodule: #{value}"
      end

      # @private
      def _submodule(value)
        defined?(super) && super || [:"close-open-topic", :"edit-header", :"edit-post", :"edit-title", :"edit-topic-summary", :"lock-topic", :"moderate-post", :"moderate-topic", :"new-topic", :reply, :"undo-edit-header", :"undo-edit-post", :"undo-edit-topic-summary", :"view-header", :"view-post", :"view-post-history", :"view-topic", :"view-topic-history", :"view-topic-summary", :"view-topiclist"].include?(value.to_sym) && merge(submodule: value.to_s).submodule({close_open_topic: Modules::CloseOpenTopic, edit_header: Modules::EditHeader, edit_post: Modules::EditPost, edit_title: Modules::EditTitle, edit_topic_summary: Modules::EditTopicSummary, lock_topic: Modules::LockTopic, moderate_post: Modules::ModeratePost, moderate_topic: Modules::ModerateTopic, new_topic: Modules::NewTopic, reply: Modules::Reply, undo_edit_header: Modules::UndoEditHeader, undo_edit_post: Modules::UndoEditPost, undo_edit_topic_summary: Modules::UndoEditTopicSummary, view_header: Modules::ViewHeader, view_post: Modules::ViewPost, view_post_history: Modules::ViewPostHistory, view_topic: Modules::ViewTopic, view_topic_history: Modules::ViewTopicHistory, view_topic_summary: Modules::ViewTopicSummary, view_topiclist: Modules::ViewTopiclist}[value.to_sym])
      end

      # The page to take the action on.
      #
      # @param value [String]
      # @return [self]
      def page(value)
        merge(page: value.to_s)
      end

      # A token retrieved from action=query&meta=tokens
      #
      # @param value [String]
      # @return [self]
      def token(value)
        merge(token: value.to_s)
      end
    end
  end
end
