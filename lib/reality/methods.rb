require 'forwardable'

module Reality
  module Methods
    def Entity(name)
      Entity.load(name)
    end

    def List(*names)
      List.new(*names)
    end

    def Measure(*arg)
      Measure.new(*arg)
    end

    extend Forwardable
    def_delegators Dictionaries, :countries, :continents
  end
end
