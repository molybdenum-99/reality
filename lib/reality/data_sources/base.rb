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

        attr_reader :symbol

        def register(symbol)
          @symbol = symbol
          name = self.name
          DataSources.instance_eval(<<-METHOD, __FILE__, __LINE__
            def #{symbol}
              @#{symbol} ||= #{name}.new
            end
          METHOD
          )
        end
      end

      def get(identity)
        get_hash(identity).map { |key, val|
          Variable.new(key, [Observation.new(Time.now, val, source: self.class.symbol)])
        }
      end
    end
  end
end
