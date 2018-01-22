module Reality
  # @private
  module Refinements
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

    refine MatchData do
      def to_h
        names.map(&:to_sym).zip(captures).to_h
      end
    end
  end
end
