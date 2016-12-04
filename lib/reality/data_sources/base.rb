module Reality
  module DataSources
    using Reality::Refinements

    class Base
      class << self
        def rules
          @rules ||= []
        end

        def rule(name, &block)
          @rules << [name, block]
        end
      end
    end
  end
end
