# frozen_string_literal: true

require 'json'

module Reality::Describers::Wikidata::Impl
  # Thin wrapper around MediaWiki API response.
  #
  # It provides services for separating metadata of response of its essential data, continuing multi-
  # page responses, and converting response errors into exceptions.
  #
  # You should not instantiate this class, it is obtained by some {Actions Action}'s {Actions::Base#response #response}.
  class Response
    # Response fail was returned by target MediaWiki API.
    Error = Class.new(RuntimeError)

    # @private
    METADATA_KEYS = %w[error warnings batchcomplete continue success limits].freeze

    # @private
    def self.parse(action, response_body)
      new(action, JSON.parse(response_body))
    end

    # Entire response "as is", including contents and metadata parts.
    #
    # See {#to_h} for content part of the response and {#metadata} for metadata part.
    #
    # @return [Hash]
    attr_reader :raw

    # Metadata part of the response, keys like "error", "warnings", "continue".
    #
    # See {#to_h} for content part of the response and {#raw} for entire response.
    #
    # @return [Hash]
    attr_reader :metadata

    # @private
    def initialize(action, response_hash)
      @action = action
      @raw = response_hash.freeze
      @metadata, @data = response_hash.partition { |key, _| METADATA_KEYS.include?(key) }.map(&:to_h).map(&:freeze)
      error! if @metadata['error']
    end

    # "Content" part of the response as a plain Ruby Hash.
    #
    # @return [Hash]
    def to_h
      # For most of actions, like query, all response is inside additional "query" key,
      # ...but not for all.
      @data.key?(@action.name) ? @data.fetch(@action.name) : @data
    end

    # Fetches a key from response content.
    #
    # @param key [String] Key name.
    def [](key)
      to_h[key]
    end

    # Digs for a keys from response content.
    #
    # @param keys [Array<String>] Key names.
    def dig(*keys)
      hash_dig(to_h, *keys)
    end

    # Returns `true` if there is next pages of response. See also {#continue}
    def continue?
      @metadata.key?('continue')
    end

    # Continues current request and returns current & next pages merged. (Merging is necessary
    # because MediaWiki tends to return the same object's data continued on the next request page.)
    #
    # @return [Response]
    def continue
      fail 'This is the last page' unless continue?

      action = @action.merge(@metadata.fetch('continue'))

      self.class.new(action, merge_responses(JSON.parse(action.perform)))
    end

    # @return [String]
    def inspect
      "#<#{self.class.name}(#{@action.name}): #{to_h.keys.join(', ')}#{' (can continue)' if continue?}>"
    end

    private

    def merge_responses(new_response)
      merger = lambda do |_k, v1, v2|
        if v1.is_a?(Hash) && v2.is_a?(Hash)
          v1.merge(v2, &merger)
        elsif v1.is_a?(Array) && v2.is_a?(Array)
          v1 + v2
        else
          v2
        end
      end

      # Newest page is responsible for all metadata, so we take entire new response and only data
      # part of old one.
      #
      # Deep recursive merge is necessary because MediaWiki could split response in parts unpredicatably
      # (like ['query']['pages'][some_page_id] can be present on several pages, providing different
      # parts of a page).
      @data.merge(new_response, &merger)
    end

    def error!
      fail Error, hash_dig(@metadata, 'error', 'info')
    end

    # TODO: replace with Hash#dig when minimal Ruby version would be 2.3
    def hash_dig(hash, *keys)
      keys.inject(hash) { |res, key| res[key] or return nil }
    end
  end
end
