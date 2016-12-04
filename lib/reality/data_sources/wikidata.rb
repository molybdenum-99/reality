require_relative 'base'

module Reality
  module DataSources
    using Reality::Refinements

    class Wikidata < Base
      class << self
        def predicate(pred, name, type, &block)
          rule(name) { |entity| type.parse(entity[pred].first.to_s) }
        end
      end

      def get(id)
        Reality::Wikidata::Entity.one_by_id(id).derp(&method(:entity_to_hash))
      end

      private

      def entity_to_hash(entity)
        {
          id: entity.id
        }.merge(self.class.rules.map { |name, block| [name, block.call(entity)] }.to_h.compact)
      end
    end
  end
end
