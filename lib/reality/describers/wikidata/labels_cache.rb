module Reality
  module Describers
    class Wikidata
      # Cache able to do `cache['Q212'] # => 'Ukraine'` and batch-fetching of new values.
      #
      # From external point of view, it just "knows" where in entity structure labels are, fetches
      # all of them in as few requests as possible, and store in cache for further access as
      # `cache[wikidata_id]`.
      #
      # From internal point of view, it stores several different cache files separately:
      # * unit names;
      # * property names;
      # * other links from entity.
      #
      # The idea is to be able to cleanup / manage / update cache files separately ("other links"
      # can grew pretty large and probably needs rotation, for example).
      #
      class LabelsCache
        CACHE_PATH = File.expand_path('~/.reality/cache/wikidata')
        FACETS = %i[properties units entities]

        def initialize(api)
          @api = api
          load_cache
        end

        def update_from(entity)
          claims = entity.fetch('claims')
          values = Hm(claims.values).dig(:*, :*, 'mainsnak', 'datavalue').flatten(1)
          cache_facets(
            properties: claims.keys,
            entities: values
              .select { |v| v['type'] == 'wikibase-entityid' }
              .map { |v| v.dig('value', 'id') },
            units: values
              .select { |v| v['type'] == 'quantity' }
              .map { |v| v.dig('value', 'unit') }.grep_v('1')
              .map(&method(:url2id))
          )
        end

        def [](id)
          @cache[id]
        end

        private

        def load_cache
          ensure_directories
          @cache = FACETS
            .map { |f| File.join(CACHE_PATH, "#{f}.yml") }
            .select(&File.method(:exist?))
            .map(&YAML.method(:load_file))
            .reduce({}, :merge)
        end

        def store_cache(facets)
          facets.each do |name, ids|
            path = File.join(CACHE_PATH, "#{name}.yml")
            existing = File.exist?(path) ? YAML.load_file(path) : {}
            next if (ids - existing.keys).none?
            File.write path, existing.merge(@cache.slice(*ids)).to_yaml
          end
        end

        def ensure_directories
          FileUtils.mkdir_p CACHE_PATH
          @enabled = true
        rescue => e
          warn "Cache can't be created and is disabled"
          @enabled = false
        end

        def cache_facets(facets)
          ids = facets.values.flatten.uniq - @cache.keys
          @cache.update(fetch_ids(*ids))
          store_cache(facets)
        end

        def fetch_ids(*ids)
          return {} if ids.empty?

          # wbgetentities have no pagination, so we need to implement it on client
          ids.each_slice(50)
          .map { |ids|
            @api.wbgetentities.ids(*ids).props(:labels).languages(:en).response['entities']
          }
          .reduce(:merge)
          .map { |k,v| [k, v.dig('labels', 'en', 'value')] }.to_h
        end

        def url2id(url)
          url.scan(%r{entity/(Q\d+)}).flatten.first or fail("Unparseable wikidata link #{url}")
        end
      end
    end
  end
end
