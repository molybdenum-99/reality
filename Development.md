**TODO**: A lot could be written here. And will be, eventually.

But for now...

## Testing describers

The describer functionality basically falls in two big parts:

1. send proper requests to described service and not fail on its response;
2. how exactly the response is parsed into entity fields.

The (1) is advised to test in normal RSpec, using VCR and probably `expect(WebMock).to have_requested`,
like this:

```ruby
RSpec.describe MyDescriber do
  describe '#query' do
    before { MyDescriber.new.query(params).load }

    context 'with :some param' do
      let(:params) { {some: "value"} }
      it {
        expect(WebMock).to have_requested(:get, %r{particular/service/path})
          .with(query: hash_including(param1: "value1", param2: "value2"))
      }
  end
end
```

For testing entities, we suggest different approach. The idea is:

* entities has many fields, and writing tests for all of them one-by-one is tiresome;
* for services with heterogenous entities, it makes a sense to try tens of them, and normal RSpec
  tests would become unbelievable.

Proposed approach is:

```ruby
require 'helpers/entities'

RSpec.describe Reality::Describers::Wikipedia, 'entities' do
  extend EntitiesHelper

  entity('Argentina')
```

This all you need to test the fact "Argentina is extracted from Wikipedia correctly". What this
code does:

* on first run, it fetches and parses entity, and stores it in readable format in `spec/entities/Argentina.yml`;
* you can examine this file manually, and see what was right, what was wrong, and what was unparsed;
* on subsequent runs, entity is fetched and rendered to the same format, and result is compared
  with one stored in `spec/entities/Argentina.yml`, and spec fails if they are different;
* you can rewrite the `.yml` with `SEED_ENTITIES=true rspec` or `SEED_ENTITES=Argentina rspec spec/path/to/particular/describer_spec.rb`;
* everything is runned under VCR, so the test effectively tests only parsing of the same source data.

How it is supposed to be used:

* If you just started, you just run it with `SEED_ENTITIES` each time, and observe changes manually,
  tweaking your describer;
* If you refactored the describer without change of functionality, specs quikly will tell you if
  something got broken (some fields are missing, parsed in a different way or renamed);
* If you updating existing describer, you run it with `SEED_ENTITIES`, and
  `git diff spec/entities/Argentina.yml` will tell you exactly what changed and you'll see if it is
  for bad or for good.
