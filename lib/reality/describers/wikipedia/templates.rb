module Reality
  module Describers
    class Wikipedia
      module Templates
        module_function

        COORD_ATTRS = {
          8 => %i[latd latm lats lath lngd lngm lngs lngh],
          6 => %i[latd latm lath lngd lngm lngh]
          4 => %i[lat lath lng lngh]
          2 => %i[lat lng]
        }.freeze

        def coord(template)
          vals = template.unnamed_variables.map(&:text).grep_v(/:/)

          num = vals.count == 2 ? 2 :
            vals.index('E') || vals.index('W') or fail("Unparseable coord #{vals.inspect}")
          vals = vals.first(num + 1).map { |t| t =~ /[SNEW]/ ? t : t.to_f }
          names = COORD_ATTRS.fetch(vals.count) { fail("Unparseable coord #{vals.inspect}") }
          Geo::Coord.new(names.zip(vals).to_h)
        end

        def date(template)
          Date.new(*template.unnamed_variables.map(&:text).first(3).map(&:to_i))
        end
      end
    end
  end
end
