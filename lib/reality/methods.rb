require 'forwardable'

module Reality
  module Methods
    def entity(name, entity_class = nil)
      Entity.load(name, entity_class)
    end

    def list(*names)
      Entity::List.new(*names)
    end

    extend Forwardable
    def_delegators Dictionaries, :countries, :continents
  end
end
