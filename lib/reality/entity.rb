require_relative 'variable'
require_relative 'observation'

module Reality
  class Entity
    attr_reader :variables, :sources

    def initialize(variables: [], sources: {})
      @variables = variables
      @sources = sources
    end

    def update(variables)
      variables.each do |var|
        existing = @variables.detect { |ex| ex.name == var.name }
        if existing
          existing.update(var)
        else
          @variables << var
        end
      end
    end

    def method_missing(sym, *arg)
      super if sym =~ /!\?=$/ || arg.count > 1

      var = @variables.detect { |v| v.name == sym } or return nil
      arg.first ? var.from(arg.first) : var
    end

    def load!
      sources.each do |source, identity|
        update(DataSources[source].get(identity))
      end
    end
  end
end
