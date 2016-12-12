require 'reality/data_sources'

module Reality
  describe DataSources::Base do
    def var(name, *observations)
      Variable.new(name, observations.map(&method(:obs)))
    end

    def obs(*args)
      return args.first if args.first.is_a?(Observation)
      Observation.new(args[0], args[1], source: args[2])
    end

    let(:tm) { Time.parse('2016-05-01 14:20') }

    before { Timecop.freeze(tm) }
    after { Timecop.return }

    describe 'wrapping hash of values into list of variables' do
      class Dummy < DataSources::Base
        register :dummy

        def get_hash(identity)
          {
            one: 1,
            two: 'three'
          }
        end
      end

      let(:source) { Dummy.new }

      subject { source.get('foo') }

      it { is_expected.to eq [var(:one, obs(tm, 1, :dummy)), var(:two, obs(tm, 'three', :dummy))] }
    end
  end
end
