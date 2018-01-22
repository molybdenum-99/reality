module Reality
  module Miracles
    module EntityMethods
      def method_missing(name, *arg, &block)
        super if !arg.empty? && block.nil? && _symbolic_names.key?(name)
        _symbolic_names.fetch(name)
      end

      def respond_to_missing?(name, *)
        _symbolic_names.key?(name)
      end

      private

      memoize def _symbolic_names
        observations.group_by { |o| nameify(o.label) }.to_h
      end

      def nameify(name)
        # TODO: Something(s) => somethings
        name.downcase.gsub(/\([^)]+\)/, '').gsub(/[^a-z_0-9]/, '_').sub(/(^_+|_+$)/, '')
      end
    end

    module LinkMethods
      def method_missing(name, *arg, &block)
        entity.method_missing(name, *arg, &block)
      end

      def respond_to_missing?(name, *)
        entity.respond_to_missing?(name)
      end

      private

      memoize def entity
        load
      end
    end
  end

  Entity.prepend Miracles::EntityMethods
  Link.prepend Miracles::LinkMethods
end
