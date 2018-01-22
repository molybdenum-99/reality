require 'infoboxer'
require 'reality/describers/wikipedia/parsers'

include Reality

RSpec.describe Reality::Describers::Wikipedia::Parsers do
  describe '#try_parse_text' do
    subject { described_class.method(:text) }

    its_call('111') { is_expected.to ret 111 }
    its_call('111 times') { is_expected.to ret '111 times' }
    its_call('73.8') { is_expected.to ret 73.8 }
    its_call('42,418,235') { is_expected.to ret 42_418_235 }
    its_call('17 August 1649') { is_expected.to ret Date.new(1649, 8, 17) }
    its_call('+3', 'utc_offset_DST') { is_expected.to ret TZOffset.parse('+3') }
    its_call('115th', 'population_density_rank') { is_expected.to ret 115 }
    its_call('10', 'area_km2') { is_expected.to ret Measure['km²'].new(10) }
    its_call('10', 'population_density_km2') { is_expected.to ret Measure['people/km²'].new(10) }
    its_call('10', 'population_total') { is_expected.to ret Measure['people'].new(10) }
    its_call('$104 billion') { is_expected.to ret Measure['$'].new(104_000_000_000) }
    its_call('−4.2', 'elevation_min_m') { is_expected.to ret Measure['m'].new(-4.2) }

    # TODO:
    # its_call('74% Russians') { is_expected.to ret WHAT }
    # its_call('2017', 'GDP_nominal_year') { is_expected.to ret Period.new(year: 2017) }
  end
end
