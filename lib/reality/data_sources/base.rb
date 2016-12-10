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

        def register(name)
          @name = name
          class_name = self.name
          DataSources.instance_eval(<<-METHOD, __FILE__, __LINE__
            def #{name}
              @#{name} ||= #{class_name}.new
            end
          METHOD
          )
        end
      end
    end
  end
end
