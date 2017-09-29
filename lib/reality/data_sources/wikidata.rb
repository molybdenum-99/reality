require 'time'

module Reality
  using Refinements

  module DataSources
    class Wikidata
      def initialize
        @api = Impl::Api.new(user_agent: Reality::USER_AGENT)
        @units = {}
      end

      def id(i)
        @api
          .wbgetentities.ids(i).sites(:enwiki)
          .props(:info, :sitelinks, :claims).languages(:en)
          .response['entities'].values.first
          .derp(&method(:process_entity))
      end

      def get(title)
        @api
          .wbgetentities.titles(title).sites(:enwiki)
          .props(:info, :sitelinks, :claims).languages(:en)
          .response['entities'].values.first
          .derp(&method(:process_entity))
      end

      private

      def process_entity(entity)
        [process_basics(entity), process_sitelinks(entity), process_claims(entity)].flatten(1)
      end

      def process_basics(entity)
        %w[id title].map { |key| [key, entity.fetch(key)] }
      end

      def process_sitelinks(entity)
        entity['sitelinks'].select { |key, _| key.start_with?('en') }.map { |key, link| ['source', "#<Link[#{key}:#{link['title']}]>"] }
      end

      def process_claims(entity)
        property_names = fetch_properties(entity)

        extract_units(entity)

        entity['claims']
          .flat_map { |id, values| values.map(&method(:parse_value)).compact.map { |v| [property_names.fetch(id), v] } }
          .sort_by(&:first)
      end

      def parse_value(snak)
        datavalue = snak.dig('mainsnak', 'datavalue')
        value = datavalue['value']
        # TODO: snack qualifiers:
        # time
        case datavalue['type']
        when 'string'
          # TODO: find list of all types!!!
          case snak.dig('mainsnak', 'datatype')
          when 'commonsMedia'
            "#<Link[commons:#{value}]>"
          when 'string'
            value
          when 'external-id'
            "#<Id[#{value}]>"
          when 'url'
            "#<URL[#{value}]>"
          when 'math'
            "#<Math[#{value}]>"
          else
            fail("Unknown snak type #{snak}")
          end
        when 'wikibase-entityid'
          "#<Link[#{value['id']}]>"
        when 'quantity'
          Measure[unit(value['unit'])].new(value['amount'].to_f)
        when 'monolingualtext'
          value['language'] == 'en' ? value['text'] : nil
        when 'globecoordinate'
          # TODO: has globe, check Mars
          Geo::Coord.new(value['latitude'], value['longitude'])
        when 'time'
          # TODO: has timezone, calendar and other stuff
          begin
            Time.parse(value['time'])
          rescue ArgumentError
            # TODO: period: "+1552-00-00T00:00:00Z"
            value['time']
          end
        else
          fail("Unknown datavalue type #{datavalue}")
        end.tap { |v| p snak if v == 'Cs-Japonsko.ogg' }
      end

      def unit(url)
        url == '1' and return 'item' # TODO: Measure[nil].new(1) #=> 1
        id = url.scan(%r{entity/(Q.+)}).flatten.first or fail("Unparseable unit #{url}")
        @units.fetch(id).gsub(/[^a-z0-9]/i, '_')
      end

      def extract_units(entity)
        # TODO: friendly synonyms; cache of well-knowns
        ids = entity['claims'].values.flatten.map { |c| c.dig('mainsnak', 'datavalue', 'value', 'unit') rescue nil }
          .compact.uniq.reject { |u| u == '1'}
          .map { |u| u.scan(%r{entity/(Q.+)}).flatten.first or fail("Unparseable unit #{u}") }

        return if ids.empty?
        @api
          .wbgetentities
          .ids(*(ids - @units.keys)).props(:labels).languages(:en)
          .response['entities'].map { |k,v| [k, v.dig('labels', 'en', 'value')]}.to_h
          .derp(&@units.method(:update))
      end

      def fetch_properties(entity)
        entity['claims'].keys.each_slice(50).map { |ids|
          @api
            .wbgetentities
            .ids(*ids).props(:labels).languages(:en)
            .response['entities']
        }.reduce(:merge)
        .map { |k,v| [k, v.dig('labels', 'en', 'value')]}.to_h
      end
    end
  end
end

require_relative 'wikidata/api'
