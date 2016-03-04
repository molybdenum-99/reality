require 'forwardable'

module Reality
  module Methods
    def Entity(name, entity_class = nil)
      Entity.load(name, entity_class)
    end

    def List(*names)
      Entity::List.new(*names)
    end

    extend Forwardable
    def_delegators Dictionaries, :countries, :continents
  end
end
