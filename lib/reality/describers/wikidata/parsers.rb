module Reality
  module Describers
    class Wikidata
      module Parsers
        module_function

        def snak(snak, cache)
          return nil if snak.dig('mainsnak', 'snaktype') == 'novalue'

          datavalue = snak.dig('mainsnak', 'datavalue')
          value = datavalue.fetch('value')
          # TODO: snack qualifiers:
          #   time
          #   relates to part... - ???
          case datavalue.fetch('type')
          when 'string'
            string_snak(value, snak.dig('mainsnak', 'datatype'))
          when 'wikibase-entityid'
            Link.new('wikidata', value['id'], title: cache[value['id']])
          when 'quantity'
            num = value['amount'].to_f
            fetch_unit(value['unit'], cache)
              .yield_self { |u| u ? Measure[u].new(num) : num }
          when 'monolingualtext'
            value['language'] == 'en' ? value['text'] : nil
          when 'globecoordinate'
            # TODO: has globe, check Mars
            Coord.new(*value.values_at('latitude', 'longitude'))
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
            Link.new('wikimedia-commons', "File:#{value}")
          when *%w[string url math external-id]
            # TODO: external id + property name => link
            value
          when 'tabular-data'
            Link.new('wikimedia-commons', value)
          else
            fail("Unknown snak type #{type.inspect} for #{value.inspect}")
          end
        end

        def fetch_unit(url, cache)
          # TODO: Measure[nil].new(1) #=> 1
          # TODO: square_kilometers => km² and so on
          return if url == '1'
          id = url.scan(%r{entity/(Q.+)}).flatten.first or fail("Unparseable unit #{u}")
          cache[id].gsub(/[^a-z0-9]/i, '_')
        end
      end
    end
  end
end
