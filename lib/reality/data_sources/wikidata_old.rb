module Reality
  using Refinements

  module DataSources
    class Wikidata
      SITEMAP = {
        enwiki: :wikipedia
      }.freeze


      def initialize(predicates = {})
        @predicates = predicates
        @api = Impl::Api.new(user_agent: Reality::USER_AGENT)
      end

      def predicate(id, name, *)
        # TODO: custom converters
        @predicates[id] = name
      end

      def find(id)
        @api
          .wbgetentities.ids(id).props(:info, :sitelinks, :claims).sitefilter(:enwiki).languages(:en)
          .response.dig('entities', id) # TODO: what if not found?
          .derp { |entity|
            [
              Observation.new(:_source, Link.new(:wikidata, id)),
              *entity['claims'].flat_map { |id, claims| claims2observations(id, claims) }
                .compact
                .reject { |o| o.value.nil? },
              *entity['sitelinks']
                .map { |site, link| Observation.new(:_source, Link.new(SITEMAP.fetch(site.to_sym), link.fetch('title'))) }
            ]
          }
      end

      private

      def claims2observations(id, claims)
        claims.map { |c| Observation.new(convert_predicate(id), convert_value(c.dig('mainsnak', 'datavalue'))) }
      end

      def convert_predicate(id)
        @predicates.fetch(id.to_sym, "_#{id}".to_sym)
      end

      def convert_value(val)
        case val['type']
        when 'string'
          val['value']
        else
          #fail ArgumentError, "Unprocessabel type: #{val['type']}"
        end
      end
    end
  end
end

require_relative 'wikidata/api'
