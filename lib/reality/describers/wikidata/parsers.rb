module Reality
  module Describers
    class Wikidata
      module Parsers
        module_function

        def snak(snak, units)
          datavalue = snak.dig('mainsnak', 'datavalue')
          value = datavalue.fetch('value')
          # TODO: snack qualifiers:
          #   time
          case datavalue.fetch('type')
          when 'string'
            string_snak(value, snak.dig('mainsnak', 'datatype'))
          when 'wikibase-entityid'
            Link.new('wikidata', value['id'])
          when 'quantity'
            Measure[units.get(value['unit'])].new(value['amount'].to_f)
          when 'monolingualtext'
            value['language'] == 'en' ? value['text'] : nil
          when 'globecoordinate'
            # TODO: has globe, check Mars
            Geo::Coord.new(*value.values_at('latitude', 'longitude'))
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
          end
        end

        def string_snak(value, type)
          # TODO: find list of all types!!!
          case type
          when 'commonsMedia'
            Link.new('wikimedia-commons', value)
          when *%w[string url math external-id]
            # TODO: external id + property name => link
            value
          else
            fail("Unknown snak type #{snak}")
          end
        end
      end
    end
  end
end
