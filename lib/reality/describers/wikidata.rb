module Reality
  module Describers
    class Wikidata < Abstract::Base
      def initialize
        @api = Impl::Api.new(user_agent: Reality::USER_AGENT)
        @units = Units.new(&method(:labels_for))
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

      #def get(title)
        #@api
          #.wbgetentities.titles(title).sites(:enwiki)
          #.props(:info, :sitelinks, :claims).languages(:en)
          #.response['entities'].values.first
          #.yield_self(&method(:process_entity))
      #end

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

      def process_basics(entity)
        # TODO: labels, descriptions, aliases
        %w[id title].map { |key| ["meta.#{key}", entity.fetch(key)] }
      end

      def process_sitelinks(entity)
        entity['sitelinks'].select { |key, _| key.start_with?('en') }
          .map { |key, link| ['meta.sitelinks', Link.new(key, link.fetch('title'))] }
      end

      def process_claims(entity)
        property_names = labels_for(*entity['claims'].keys)
        @units.update_from(entity)

        entity['claims']
          .map { |id, snaks| [property_names.fetch(id), *process_snaks(snaks)] }
          .reject { |_, val, _| val.nil? }
      end

      def process_snaks(snaks)
        values = snaks.map { |s| Parsers.snak(s, @units) }.compact
        return if values.empty?
        [
          values.one? ? values.first : values,
          source: snaks
        ]
      end

      def labels_for(*ids)
        # wbgetentities have no pagination, so we need to implement it on client
        ids.each_slice(50).map { |ids|
          query(@api.wbgetentities.ids(*ids).props(:labels).languages(:en))['entities']
        }.reduce(:merge)
        .map { |k,v| [k, v.dig('labels', 'en', 'value')] }.to_h
      end
    end
  end
end

require_relative 'wikidata/api'
require_relative 'wikidata/parsers'
require_relative 'wikidata/units'
