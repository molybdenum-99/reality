module Reality
  class Entity
    module Extension
      class << self
        def list
          @list ||= []
        end

        def apply_to(entity)
          return if @disabled
          list
            .select { |block, mod| block.call(entity) rescue false }
            .map(&:last).each(&entity.method(:extend))
        end

        def disable!
          @disabled = true
        end
      end

      def condition(&block)
        Extension.list << [block, self] unless self.eql?(Extension)
      end
    end
  end
end
