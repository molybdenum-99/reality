# frozen_string_literal: true

require 'addressable'
require 'faraday'
require 'faraday_middleware'

module Reality::DataSources::Wikidata::Impl
  # Internal low-level client class, used by {Api}.
  #
  # Uses [Faraday](https://github.com/lostisland/faraday) library inside (and will expose it's settings
  # in future).
  #
  # You should not use it directly, all you need is in {Api}.
  class Client
    # Default MediaWiktory User-Agent header.
    #
    # You can set yours as an option to {#initialize}
    UA = 'MediaWiktory/0.1.0 '\
         '(https://github.com/molybdenum-99/mediawiktory; zverok.offline@gmail.com)'

    class << self
      # User agent getter/setter.
      #
      # Default value is {UA}.
      #
      # You can also use per-instance option, see {#initialize}
      attr_accessor :user_agent
    end

    attr_reader :url

    def initialize(url, **options)
      @url = Addressable::URI.parse(url)
      @options = options
      @faraday = Faraday.new(url) do |f|
        f.request :url_encoded
        f.use FaradayMiddleware::FollowRedirects, limit: 5
        f.adapter Faraday.default_adapter
      end
      @faraday.headers.merge!(headers)
    end

    def user_agent
      @options[:user_agent] || @options[:ua] || self.class.user_agent || UA
    end

    def get(params)
      @faraday.get('', params).body
    end

    def post(params)
      @faraday.post('', params).body
    end

    private

    def headers
      {'User-Agent' => user_agent}
    end
  end
end
