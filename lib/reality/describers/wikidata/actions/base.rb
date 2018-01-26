# frozen_string_literal: true

require_relative '../response'

module Reality::Describers::Wikidata::Impl
  module Actions
    # Global setup methods included into every action through {Base}.
    module GlobalParams

      # The format of the output.
      #
      # @param value [Symbol] Selecting an option includes tweaking methods from corresponding module:
      #   * `:json` - {Reality::Describers::Wikidata::Impl::Modules::Json} Output data in JSON format.
      #   * `:jsonfm` - {Reality::Describers::Wikidata::Impl::Modules::Jsonfm} Output data in JSON format (pretty-print in HTML).
      #   * `:none` - {Reality::Describers::Wikidata::Impl::Modules::None} Output nothing.
      #   * `:php` - {Reality::Describers::Wikidata::Impl::Modules::Php} Output data in serialized PHP format.
      #   * `:phpfm` - {Reality::Describers::Wikidata::Impl::Modules::Phpfm} Output data in serialized PHP format (pretty-print in HTML).
      #   * `:rawfm` - {Reality::Describers::Wikidata::Impl::Modules::Rawfm} Output data, including debugging elements, in JSON format (pretty-print in HTML).
      #   * `:xml` - {Reality::Describers::Wikidata::Impl::Modules::Xml} Output data in XML format.
      #   * `:xmlfm` - {Reality::Describers::Wikidata::Impl::Modules::Xmlfm} Output data in XML format (pretty-print in HTML).
      # @return [self]
      def format(value)
        _format(value) or fail ArgumentError, "Unknown value for format: #{value}"
      end

      # @private
      def _format(value)
        [:json, :jsonfm, :none, :php, :phpfm, :rawfm, :xml, :xmlfm].include?(value.to_sym) && merge(format: value.to_s).submodule({json: Modules::Json, jsonfm: Modules::Jsonfm, none: Modules::None, php: Modules::Php, phpfm: Modules::Phpfm, rawfm: Modules::Rawfm, xml: Modules::Xml, xmlfm: Modules::Xmlfm}[value.to_sym])
      end

      # Maximum lag can be used when MediaWiki is installed on a database replicated cluster. To save actions causing any more site replication lag, this parameter can make the client wait until the replication lag is less than the specified value. In case of excessive lag, error code maxlag is returned with a message like Waiting for $host: $lag seconds lagged.See Manual: Maxlag parameter for more information.
      #
      # @param value [Integer]
      # @return [self]
      def maxlag(value)
        merge(maxlag: value.to_s)
      end

      # Set the s-maxage HTTP cache control header to this many seconds. Errors are never cached.
      #
      # @param value [Integer]
      # @return [self]
      def smaxage(value)
        merge(smaxage: value.to_s)
      end

      # Set the max-age HTTP cache control header to this many seconds. Errors are never cached.
      #
      # @param value [Integer]
      # @return [self]
      def maxage(value)
        merge(maxage: value.to_s)
      end

      # Verify the user is logged in if set to user, or has the bot user right if bot.
      #
      # @param value [String] One of "user", "bot".
      # @return [self]
      def assert(value)
        _assert(value) or fail ArgumentError, "Unknown value for assert: #{value}"
      end

      # @private
      def _assert(value)
        defined?(super) && super || ["user", "bot"].include?(value.to_s) && merge(assert: value.to_s)
      end

      # Verify the current user is the named user.
      #
      # @param value [String]
      # @return [self]
      def assertuser(value)
        merge(assertuser: value.to_s)
      end

      # Any value given here will be included in the response. May be used to distinguish requests.
      #
      # @param value [String]
      # @return [self]
      def requestid(value)
        merge(requestid: value.to_s)
      end

      # Include the hostname that served the request in the results.
      #
      # @return [self]
      def servedby()
        merge(servedby: 'true')
      end

      # Include the current timestamp in the result.
      #
      # @return [self]
      def curtimestamp()
        merge(curtimestamp: 'true')
      end

      # Include the languages used for uselang and errorlang in the result.
      #
      # @return [self]
      def responselanginfo()
        merge(responselanginfo: 'true')
      end

      # When accessing the API using a cross-domain AJAX request (CORS), set this to the originating domain. This must be included in any pre-flight request, and therefore must be part of the request URI (not the POST body).
      #
      # @param value [String]
      # @return [self]
      def origin(value)
        merge(origin: value.to_s)
      end

      # Language to use for message translations. action=query&meta=siteinfo with siprop=languages returns a list of language codes, or specify user to use the current user's language preference, or specify content to use this wiki's content language.
      #
      # @param value [String]
      # @return [self]
      def uselang(value)
        merge(uselang: value.to_s)
      end

      # Format to use for warning and error text output.
      #
      # @param value [String] One of " plaintext" ( Wikitext with HTML tags removed and entities replaced), " wikitext" ( Unparsed wikitext), " html" ( HTML), " raw" ( Message key and parameters), " none" ( No text output, only the error codes), " bc" ( Format used prior to MediaWiki 1.29. errorlang and errorsuselocal are ignored).
      # @return [self]
      def errorformat(value)
        _errorformat(value) or fail ArgumentError, "Unknown value for errorformat: #{value}"
      end

      # @private
      def _errorformat(value)
        defined?(super) && super || [" plaintext", " wikitext", " html", " raw", " none", " bc"].include?(value.to_s) && merge(errorformat: value.to_s)
      end

      # Language to use for warnings and errors. action=query&meta=siteinfo with siprop=languages returns a list of language codes, or specify content to use this wiki's content language, or specify uselang to use the same value as the uselang parameter.
      #
      # @param value [String]
      # @return [self]
      def errorlang(value)
        merge(errorlang: value.to_s)
      end

      # If given, error texts will use locally-customized messages from the MediaWiki namespace.
      #
      # @return [self]
      def errorsuselocal()
        merge(errorsuselocal: 'true')
      end

      # When accessing the API using a cross-domain AJAX request (CORS), use this to authenticate as the current SUL user. Use action=centralauthtoken on this wiki to retrieve the token, before making the CORS request. Each token may only be used once, and expires after 10 seconds. This should be included in any pre-flight request, and therefore should be included in the request URI (not the POST body).
      #
      # @param value [String]
      # @return [self]
      def centralauthtoken(value)
        merge(centralauthtoken: value.to_s)
      end

    end

    # Base class for all {Reality::Describers::Wikidata::Impl::Api} actions. "Actions" is MediaWiki's term for
    # different request types. Everything you are doing with your target MediaWiki installation, you
    # are doing by _performing actions_.
    #
    # Typically, you should never instantiate this class or its descendants directly, but rather by
    # {Reality::Describers::Wikidata::Impl::Api Api} methods (included from {Reality::Describers::Wikidata::Impl::Actions Actions}
    # module).
    #
    # The usual workflow with actions is:
    #
    # * Create it with `api.action_name`
    # * Set action params with subsequent `paramname(paramvalue)` calls;
    # * Perform action with {#perform} (returns row MediaWiki response as a string) or {#response}
    #   (returns {Reality::Describers::Wikidata::Impl::Response} class with parsed data and helper methods).
    #
    # Note that some of `paramname(value)` calls include new {Modules} into action, which provides
    # new params & methods. For example:
    #
    # ```ruby
    # api.query.generator(:categorymembers) # includes new methods of GCategorymembers module
    #    .title('Category:DOS_games')       # one of GCategorymembers methods, adds gcmtitle=Category:DOS_games to URL
    #    .limit(20)
    # ```
    #
    # Sometimes new modules inclusion can change a sense of already existing methods:
    #
    # ```ruby
    # api.query.titles('Argentina')
    #   .prop(:revisions)           # .prop method from Query action, adds prop=revisions to URL and includes Revisions module
    #   .prop(:content)             # .prop method from Revisions module, adds rvprop=content to URL
    # ```
    #
    # Despite of how questionable this practice looks, it provides the most obvious method chains even
    # for most complicated cases.
    #
    # Some setup methods shared between all the actions (like output format and TTL settings of
    # response) are defined in {GlobalParams}.
    #
    # Full action usage example:
    #
    # ```ruby
    # api = MediaWiktory::Wikipedia::Api.new
    # action = api.new.query.titles('Argentina').prop(:revisions).prop(:content).meta(:siteinfo)
    # # => #<MediaWiktory::Wikipedia::Actions::Query {"titles"=>"Argentina", "prop"=>"revisions", "rvprop"=>"content", "meta"=>"siteinfo"}>
    # response = action.response
    # # => #<MediaWiktory::Wikipedia::Response(query): pages, general>
    # puts response['pages'].values   # all pages...
    #   .first['revisions']           # take revisions from first...
    #   .first['*']                   # take content from first revision...
    #   .split("\n").first(3)         # and first 3 paragrapahs
    # # {{other uses}}
    # # {{pp-semi|small=yes}}
    # # {{Use dmy dates|date=March 2017}}
    # response.dig('general', 'sitename')
    # # => "Wikipedia"
    # ```
    #
    class Base
      # @private
      attr_reader :client

      # @private
      def initialize(client, options = {})
        @client = client
        @params = stringify_hash(options)
        @submodules = []
      end

      # @return [String]
      def inspect
        "#<#{self.class.name} #{to_h}>"
      end

      # Make new action, with additional params passed as `hash`. No params validations are made.
      #
      # @param hash [Hash] Params to merge. All keys and values would be stringified.
      # @return [Action] Produced action of the same type as current action was, with all passed
      #   params applied.
      def merge(hash)
        replace = hash.fetch(:replace, true)
        hash.delete(:replace)
        self.class
            .new(@client, @params.merge(stringify_hash(hash)) { |_, o, n| replace ? n : [o, n].compact.uniq.join('|') })
            .tap { |action| @submodules.each { |sm| action.submodule(sm) } }
      end

      # All action's params in a ready to passing to URL form (string keys & string values).
      #
      # @example
      #    api.query.titles('Argentina', 'Bolivia').format(:json).to_h
      #    # => {"titles"=>"Argentina|Bolivia", "format"=>"json"}
      #
      # @return [Hash{String => String}]
      def to_h
        @params.dup
      end

      # Action's name on MediaWiki API (e.g. "query" for `Query` action, "parsoid-batch" for
      # `ParsoidBatch` action and so on).
      #
      # @return [String]
      def name
        # Query # => query
        # ParsoidBatch # => parsoid-batch
        self.class.name.split('::').last.gsub(/([a-z])([A-Z])/, '\1-\2').downcase or
          fail ArgumentError, "Can't guess action name from #{self.class.name}"
      end

      # All action's params in a ready to passing to URL form (string keys & string values). Unlike
      # {#to_h}, includes also action name.
      #
      # @example
      #    api.query.titles('Argentina', 'Bolivia').format(:json).to_param
      #    # => {"titles"=>"Argentina|Bolivia", "format"=>"json", "action"=>"query"}
      #
      # @return [Hash{String => String}]
      def to_param
        to_h.merge('action' => name)
      end

      # Full URL for this action invocation.
      #
      # @example
      #    api.query.titles('Argentina', 'Bolivia').format(:json).to_url
      #    # => "https://en.wikipedia.org/w/api.php?action=query&format=json&titles=Argentina%7CBolivia"
      #
      # @return [String]
      def to_url
        url = @client.url
        url.query_values = to_param
        url.to_s
      end

      # Performs action (through `GET` or `POST` request, depending on action's type) and returns
      # raw body of response.
      #
      # @return [String]
      def perform
        fail NotImplementedError,
             'Action is abstract, all actions should descend from Actions::Get or Actions::Post'
      end

      # Performs action (as in {#perform}) and returns an instance of {Response}. It is a thing
      # wrapper around parsed action's JSON response, which separates "content" and "meta" (paging,
      # warnings/erros) fields.
      #
      # Note, that not all actions return a JSON suitable for parsing into {Response}. For example,
      # Wikipedia's [opensearch](https://en.wikipedia.org/w/api.php?action=help&modules=opensearch)
      # action returns absolutely different JSON structure, corresponding to global
      # [OpenSearch](https://en.wikipedia.org/wiki/OpenSearch) standard.
      #
      # Note also, that on erroneous request (when response contains `"error"` key), this method
      # will raise {Response::Error}.
      #
      # @return [Response]
      def response
        jsonable = format(:json)
        Response.parse(jsonable, jsonable.perform)
      end

      include GlobalParams

      private

      # Not in indepented module to decrease generated files/modules list
      def stringify_hash(hash, recursive: false)
        hash.map { |k, v|
          [k.to_s, v.is_a?(Hash) && recursive ? stringify_hash(v, recursive: true) : v.to_s]
        }.to_h
      end

      protected

      def submodule(mod)
        extend(mod)
        @submodules << mod
        self
      end
    end

    class Get < Base
      def perform
        client.get(to_param)
      end
    end

    class Post < Base
      def perform
        client.post(to_param)
      end
    end
  end
end
