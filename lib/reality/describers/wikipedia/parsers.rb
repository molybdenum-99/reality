module Reality
  module Describers
    class Wikipedia
      module Parsers
        module_function

        def text(string, label = nil)
          by_label = text_by_label(string, label) and return by_label

          case string
          when /^\d{1,2}[[:space:]]+(\w+)[[:space:]]+\d{4}([[:space:]]+BCE)?$/, /^(\w+)[[:space:]]+\d{1,2},[[:space:]]+\d{4}([[:space:]]+BCE)?$/
            Date.parse(string)
          when /^\d+$/
            string.to_i
          when /^[−-]?\d+\.\d+$/
            string.tr('−', '-').to_f
          when /^\d{1,3},(\d{3},)*\d{3}$/
            string.gsub(',', '').to_i
          when /^\$(\d{1,3},(\d{3},)*\d{3})$/
            val = Regexp.last_match[1].gsub(',', '').to_i
            Measure['$'].new(val)
          when /^\$(?<num>(\d{1,3},(\d{3},)*\d{3}|\d+)(\.\d+)?)[[:space:]]+(?<scale>#{SCALES_REGEXP})/
            num, scale = Regexp.last_match[:num], Regexp.last_match[:scale]
            val = (num.gsub(',', '').to_f * fetch_scale(scale)).to_i
            Measure['$'].new(val)
          when /^(\d+)[[:space:]]+min(utes)?$/
            Measure['min'].new(Regexp.last_match[1].to_i)
          else
            string
          end.yield_self { |val| try_make_measure(label, val) }
        end

        def text_by_label(string, label)
          return nil if label.nil?

          case label
          when /^utc_offset/
            if string.include?('/')
              string.split(%r{\s*/\s*}).map(&TZOffset.method(:parse))
                .yield_self { |offsets| offsets.any?(&:nil?) ? nil : offsets }
            else
              TZOffset.parse(string)
            end
          when /_rank$/
            string.to_i if string =~ /^\d+(\w{2})$/
          end
        end

        def try_make_measure(label, val)
          return val unless val.is_a?(Numeric)
          case label
          when /^population_density_(.*)km2$/
            'people/km²'
          when /^population_(?!density|as_of)/
            'people'
          when /(?<!density)_km2$/
            'km²'
          when /_m$/
            'm'
          end.yield_self { |unit| unit ? Measure[unit].new(val) : val }
        end

        # See "Short scale": https://en.wikipedia.org/wiki/Long_and_short_scales#Comparison
        SCALES = {
          'million'     => 1_000_000,
          'billion'     => 1_000_000_000,
          'trillion'    => 1_000_000_000_000,
          'quadrillion' => 1_000_000_000_000_000,
          'quintillion' => 1_000_000_000_000_000_000,
          'sextillion'  => 1_000_000_000_000_000_000_000,
          'septillion'  => 1_000_000_000_000_000_000_000_000,
        }
        SCALES_REGEXP = Regexp.union(*SCALES.keys)

        def fetch_scale(str)
          _, res = SCALES.detect{|key, val| str.start_with?(key)}

          res or fail("Scale not found: #{str} for #{self}")
        end
      end
    end
  end
end
