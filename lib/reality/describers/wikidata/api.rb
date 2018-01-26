# frozen_string_literal: true

require_relative './client'
require_relative './actions'

# Wrapper for [Wikidata](https://www.wikidata.org/wiki/Wikidata:Main_Page) API.
#
# _Generated from https://www.wikidata.org/w/api.php at May 11, 2017 by MediaWiktory 0.1.1._
#
# It also can be used for access to any other MediaWiki site, but some of actions could be
# non-existent/outdated.
#
# See {Reality::Describers::Wikidata::Impl::Api} for usage.
#
module Reality::Describers::Wikidata::Impl
  # Base API class for [Wikidata](https://www.wikidata.org/wiki/Wikidata:Main_Page).
  #
  # Example of usage:
  #
  # ```ruby
  # # For Wikidata
  # api = Reality::Describers::Wikidata::Impl::Api.new
  # api.some_action.some_param(value).other_param(*more_values).perform
  # # => returns raw response of MediaWiki API
  # api.some_action.some_param(value).other_param(*more_values).response
  # # => returns an instance of Response, parsed from JSON
  #
  # # For any other site:
  # api = Reality::Describers::Wikidata::Impl::Api.new('https://some.site/w/api.php')
  # # ...the same as above
  # ```
  #
  # {Actions} module lists all available API actions and refers to corresponding classes and
  # their options.
  #
  # See also {Response} for working with return values and {Actions::Base} for working with actions.
  #
  class Api
    # @private
    attr_reader :client, :defaults

    # @private
    CLIENT_OPTIONS = %i[user_agent ua].freeze

    # @param url [String] Source URL for this API, by default "".
    #   Note that most of MediaWiki installations have source URL at `/w/api.php`, but some are
    #   just `/api.php`, others use `/wiki/api.php` and so on.
    #
    # @param defaults [Hash] Default options for all API queries. Default param values also can be
    #   set by subsequent {Actions::Base} methods, like `api.some_action.json(callback: 'mycallbackname')...`
    # @option defaults [Symbol] user_agent User-Agent header for underlying client.
    # @option defaults [Symbol] format The format of the output. Selecting an option includes tweaking methods from corresponding module: See {Actions::Base#format}
    # @option defaults [Integer] maxlag Maximum lag can be used when MediaWiki is installed on a database replicated cluster. To save actions causing any more site replication lag, this parameter can make the client wait until the replication lag is less than the specified value. In case of excessive lag, error code maxlag is returned with a message like Waiting for $host: $lag seconds lagged.See Manual: Maxlag parameter for more information. See {Actions::Base#maxlag}
    # @option defaults [Integer] smaxage Set the s-maxage HTTP cache control header to this many seconds. Errors are never cached. See {Actions::Base#smaxage}
    # @option defaults [Integer] maxage Set the max-age HTTP cache control header to this many seconds. Errors are never cached. See {Actions::Base#maxage}
    # @option defaults [String] assert Verify the user is logged in if set to user, or has the bot user right if bot. One of "user", "bot". See {Actions::Base#assert}
    # @option defaults [String] assertuser Verify the current user is the named user. See {Actions::Base#assertuser}
    # @option defaults [String] requestid Any value given here will be included in the response. May be used to distinguish requests. See {Actions::Base#requestid}
    # @option defaults [true, false] servedby Include the hostname that served the request in the results. See {Actions::Base#servedby}
    # @option defaults [true, false] curtimestamp Include the current timestamp in the result. See {Actions::Base#curtimestamp}
    # @option defaults [true, false] responselanginfo Include the languages used for uselang and errorlang in the result. See {Actions::Base#responselanginfo}
    # @option defaults [String] origin When accessing the API using a cross-domain AJAX request (CORS), set this to the originating domain. This must be included in any pre-flight request, and therefore must be part of the request URI (not the POST body). See {Actions::Base#origin}
    # @option defaults [String] uselang Language to use for message translations. action=query&meta=siteinfo with siprop=languages returns a list of language codes, or specify user to use the current user's language preference, or specify content to use this wiki's content language. See {Actions::Base#uselang}
    # @option defaults [String] errorformat Format to use for warning and error text output. One of " plaintext" ( Wikitext with HTML tags removed and entities replaced), " wikitext" ( Unparsed wikitext), " html" ( HTML), " raw" ( Message key and parameters), " none" ( No text output, only the error codes), " bc" ( Format used prior to MediaWiki 1.29. errorlang and errorsuselocal are ignored). See {Actions::Base#errorformat}
    # @option defaults [String] errorlang Language to use for warnings and errors. action=query&meta=siteinfo with siprop=languages returns a list of language codes, or specify content to use this wiki's content language, or specify uselang to use the same value as the uselang parameter. See {Actions::Base#errorlang}
    # @option defaults [true, false] errorsuselocal If given, error texts will use locally-customized messages from the MediaWiki namespace. See {Actions::Base#errorsuselocal}
    # @option defaults [String] centralauthtoken When accessing the API using a cross-domain AJAX request (CORS), use this to authenticate as the current SUL user. Use action=centralauthtoken on this wiki to retrieve the token, before making the CORS request. Each token may only be used once, and expires after 10 seconds. This should be included in any pre-flight request, and therefore should be included in the request URI (not the POST body). See {Actions::Base#centralauthtoken}
    #
    def initialize(url = 'https://www.wikidata.org/w/api.php', **defaults)
      client_options, @defaults = defaults.partition { |k, _| CLIENT_OPTIONS.include?(k) }.map(&:to_h)
      @client = Client.new(url, **client_options)
    end

    def inspect
      "#<#{self.class.name}(#{@client.url})>"
    end

    include Reality::Describers::Wikidata::Impl::Actions
  end
end
