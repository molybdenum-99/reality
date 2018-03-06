module EntitiesHelper
  def entity(name)
    dir = caller.first.split(':').first.split('/')[-2]
    path = "spec/entities/#{dir}/#{name}.yml"
    cassette = "entities-#{dir}-#{name}"
    FileUtils.mkdir_p File.dirname(path)
    if !File.exists?(path) || ENV.fetch('SEED_ENTITIES', '').match(/^(true|#{name})$/i)
      entity = VCR.use_cassette(cassette) { described_class.new.get(name) }
      File.write path, serialize_entity(entity)
      puts "\"#{name}\" fetched and stored at: #{path}"
    else
      context name do
        # We comparing them just as a stings, to receive simple and readable diff
        # TODO: remove differences introduced by manual editing (eample: line endings stripped by editor)
        let(:template) { File.read(path) }
        let(:fetched) { VCR.use_cassette(cassette) { describer.get(name) } }
        subject { self.class.serialize_entity(fetched) }

        it { is_expected.to eq template }
      end
    end
  end

  def serialize_entity(e)
    {'_uri' => e.uri}
      .merge(e.observations.map { |o| [o.variable.to_s, serialize_value(o.value)] }.to_h)
      .to_yaml(line_width: 200)
      .gsub(/ *\n/, "\n") # YAML leaves " " at the end of lines on empty values, while people typically do not
  end

  # We just clean it up to produce readable YAML
  def serialize_value(v)
    case v
    when TZOffset, Geo::Coord, Reality::Link, Reality::Measure, Money::Currency
      v.inspect
    when Array
      v.map(&method(:serialize_value))
    when String, Numeric, Date, Time
      v
    else
      fail ArgumentError, "Not a basic value in the entity: #{v.inspect}"
    end
  end
end