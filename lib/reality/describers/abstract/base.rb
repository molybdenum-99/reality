module Reality
  module Describers
    module Abstract
      class Base
        extend Memoist

        def get(id)
          # we assume that child was good and returned observations about only one entity, basically
          observations_for(id) #.yield_self(&method(:make_entities)).first
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
          observations.group_by(&:entity_id).map { |(source, entity_id), group|
            Entity.new(source, entity_id, group)
          }
        end

        def obs(entity_id, name, value, time: nil)
          Observation.new(entity_id, name, value, time: time, source: descriptor)
        end

        def link(entity_id, source = nil)
          Link.new(source || descriptor, entity_id)
        end
      end
    end
  end
end
