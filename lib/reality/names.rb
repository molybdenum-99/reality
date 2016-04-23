module Reality
  # This optional and higly experimental module allows treat ALL objects
  # available with Reality, as Ruby constants (via redefined `const_missing`).
  # This practice may seem questionable, so use it wisely!
  #
  # You can just use this module on its own:
  #
  # ```ruby
  # Reality::Names::Argentina
  # # => #<Reality::Entity(Argentina):country>
  # ```
  #
  # ...Or just include it elsewhere:
  #
  # ```ruby
  # include Reality::Names
  #
  # Argentina
  # # => #<Reality::Entity(Argentina):country>
  # ```
  #
  # Multi-word entities can also be called:
  #
  # ```ruby
  # BuenosAires
  # # => #<Reality::Entity(Buenos Aires):city>
  # ```
  #
  # Though, more complicated entity names (with punctuations) can't be
  # accessed this way.
  #
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
