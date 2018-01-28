module Reality
  module Describers
    module Abstract
      class Base
        extend Memoist

        def get(id)
          # we assume that child was good and returned observations about only one entity, basically
          observations_for(id).yield_self(&method(:make_entities)).first
        end

        def query(params)
          Query.new(prefix, params)
        end

        memoize def log
          Logger.new(STDOUT)
        end

        private

        # To redefine in children
        def descriptor
          fail NotImplementedError
        end

        def observations_for(id)
          fail NotImplementedError
        end

        # Internal helpers

        def make_entities(observations)
          observations.group_by(&:entity_uri).map { |_, group|
            Entity.new(group)
          }
        end

        def obs(entity_id, name, value, source: nil, time: nil)
          Observation.new([prefix, entity_id].join(':'), name, value, time: time, source: source)
        end
      end
    end
  end
end
