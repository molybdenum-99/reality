module Reality
  module Names
    def Names.const_missing(symbol)
      name = symbol.to_s.
        gsub('_', ' ').
        gsub(/([a-z])([A-Z])/, '\1 \2')
      Reality::Entity(name) or super
    end

    def Names.included(other)
      other.define_singleton_method(:const_missing){|name|
        Reality::Names.const_missing(name)
      }
    end
  end
end
