module Reality
  module Refinements
    refine Object do
      def derp
        yield self
      end
    end

    refine Hash do
      def except(*keys)
        reject { |k, _v| keys.include?(k) }
      end
    end
  end
end
