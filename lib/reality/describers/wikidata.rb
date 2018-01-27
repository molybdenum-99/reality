module Reality
  module Describers
    class Wikidata < Abstract::Base
      def initialize
        @api = Impl::Api.new(user_agent: Reality::USER_AGENT)
        @cache = LabelsCache.new(@api)
      end

      def observations_for(id)
        @api
          .wbgetentities.ids(id).sites(:enwiki)
          .props(:info, :sitelinks, :claims, :labels, :aliases, :descriptions).languages(:en)
          .yield_self(&method(:query))['entities']
          .values.first
          .yield_self(&method(:process_entity))
          .map { |name, *arg| obs(id, name, *arg) }
      end

      def query(predicates)
      end

      private

      def prefix
        'wikidata'
      end

      def query(q)
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
          ["meta.#{key}", Util.dig(entity, *path)]
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
        values = snaks.map { |s| Parsers.snak(s, @cache) }.compact
        return if values.empty?
        [
          values.one? ? values.first : values,
          source: snaks
        ]
      end
    end
  end
end

require_relative 'wikidata/api'
require_relative 'wikidata/parsers'
require_relative 'wikidata/labels_cache'

Reality.describers['wikidata'] = Reality::Describers::Wikidata.new
