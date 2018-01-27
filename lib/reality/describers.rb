module Reality
  class << self
    extend Memoist

    # FIXME: Or something ¯\_(ツ)_/¯
    # Like proper "registering" themselves and blah blah
    memoize def describers
      {}
    end

    def wikipedia
      describers['wikipedia']
    end
  end
end
