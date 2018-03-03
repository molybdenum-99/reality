module Reality
  module Describers
    class Wikidata < Abstract::Base
      def initialize
        @api = Impl::Api.new(user_agent: Reality::USER_AGENT)
        @sparql = SparqlClient.new(log: log)
        @cache = LabelsCache.new(@api)
      end

      def observations_for(id)
        @api
          .wbgetentities.ids(id).sites(:enwiki)
          .props(:info, :sitelinks, :claims, :labels, :aliases, :descriptions).languages(:en)
          .yield_self(&method(:query_api))['entities']
          .values.first
          .yield_self(&method(:process_entity))
          .map { |name, *arg| obs(id, name, *arg) }
      end

      def perform_query(params)
        raw, processable = params.partition { |name, value| name.match(/^P\d+$/) }

        # TODO: cache names & types

        # find predicate ids
        predicates = processable.map { |name, value|
          next ['rdfs:label', 'monolingualtext', value] if name == 'label'

          prop =
            @api.wbsearchentities.search(name.gsub('_', ' '))
            .type(:property).language(:en).limit(1)
            .response['search'].first or fail ArgumentError, "Property named #{name.inspect} can not be found"
          ['wdt:' + prop.fetch('id'), prop.fetch('datatype'), value]
        }

        # find predicate types
        predicates.concat(if raw.empty?
            []
          else
            @api.wbgetentities.ids(*raw.keys).props(:datatype).yield_self(&method(:query_api))['entities']
              .map { |id, meta| ["wdt:#{id}", meta.fetch('datatype'), params.fetch(id)] }
          end
        )

        predicates = prepare_predicate_links(predicates)

        @sparql.query(predicates)
      end

      private

      def prefix
        'wikidata'
      end

      def query_api(q)
        log.debug "Requesting #{q.to_url}"
        q.response
      end

      def process_entity(entity)
        [process_basics(entity), process_sitelinks(entity), process_claims(entity)].flatten(1)
      end

      METADATA_FETCHERS = {
        id: 'id',
        title: 'title',
        label: ['labels', 'en', 'value'],
        description: ['descriptions', 'en', 'value'],
        aliases: ['aliases', 'en', :*, 'value'],
      }

      KNOWN_SITES = {
        'enwiki' => 'wikipedia:en'
      }

      def process_basics(entity)
        METADATA_FETCHERS.map { |key, path|
          ["meta.#{key}", Hm(entity).dig(*path)]
        }
      end

      def process_sitelinks(entity)
        Array(entity['sitelinks']).select { |key, _| key.start_with?('en') }
          .map { |key, link| Link.new(describer_for(key), link.fetch('title')) }
          .yield_self { |links| [['meta.sitelinks', links]] }
      end

      def describer_for(siteid)
        KNOWN_SITES.fetch(siteid, siteid)
      end

      def process_claims(entity)
        @cache.update_from(entity)

        entity['claims']
          .map { |id, snaks| [@cache[id], *process_snaks(snaks)] }
          .reject { |_, val, _| val.nil? }
      end

      def process_snaks(snaks)
        values = filter_by_rank(snaks).map { |s| Parsers.snak(s, @cache) }.compact
        return if values.empty?
        [
          values.one? ? values.first : values,
          source: snaks
        ]
      end

      SNAK_RANKS = %w[preferred normal deprecated]

      # Lot of properties can have multiple values. Sometimes they are equally important,
      # for example: "marriage age" - X applies-to-main, Y applies-to-woman,
      # but frequenly all but one/some value(s) are historical (for example: population of a country,
      # each value qualified by time). In this case the "main" value have "preferred" rank, while
      # other have "normal" (if historical) or "deprecated" rank.
      def filter_by_rank(snaks)
        main_rank = snaks.map { |s| s['rank'] }.uniq.min_by(&SNAK_RANKS.method(:index))
        snaks.reject { |s| s['rank'] != main_rank }
      end

      def prepare_predicate_links(predicates)
        predicates
          .map { |name, type, value|
            next [name, type, value] unless type == 'wikibase-item' && value.is_a?(String) && !value.match(/^Q\d+$/)
            # FIXME: allowing fuzzy match for now...
            val =
              @api.wbsearchentities.search(value).type(:item).language(:en).limit(1)
                .response['search'].first
                .yield_self { |e|
                  e.nil? and fail ArgumentError, "Entity named #{value.inspect} can not be found"
                  e.fetch('id')
                }
            [name, type, val]
          }
      end
    end
  end
end

%w[api parsers labels_cache sparql].each { |f| require_relative "wikidata/#{f}" }

Reality.describers['wikidata'] = Reality.describers['wd'] = Reality::Describers::Wikidata.new
