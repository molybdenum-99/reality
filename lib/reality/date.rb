require 'date'

module Reality
  class Date < ::Date
    def inspect
      '#<%s %s>' % [self.class.name, strftime('%Y-%m-%d')]
    end
  end
end
