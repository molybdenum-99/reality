module Reality
  # @private
  module Refinements
    refine Object do
      def derp
        yield self
      end

      alias m method
    end

    refine Hash do
      def except(*keys)
        reject { |k, _v| keys.include?(k) }
      end
    end

    refine Array do
      def group_count(&block)
        block ||= ->(x) { x }
        Hash.new{ 0 }.tap{|res|
          each do |val|
            res[block.call(val)] += 1
          end
        }
      end
    end
  end
end
