module Reality
  using Reality::Refinements

  class Observations
    attr_reader :observations

    def initialize(*observations)
      observations.map(&:type).uniq.tap { |types|
        types.size == 1 or raise(ArgumentError, "Observations have different types: #{types.join(', ')}")
      }
      observations.map(&:index).map(&:class).uniq.tap { |classes|
        classes.size == 1 or raise(ArgumentError, "Observations have different index classes: #{classes.join(', ')}")
      }
      observations.map(&:index).group_by(&:itself).select { |i, g| g.count > 1 }.tap { |groups|
        groups.empty? or raise(ArgumentError, "Observations have non-unique indexes: #{groups.keys.join(', ')}")
      }

      variables = observations.map(&:variables).flatten.uniq
      @observations = observations
        .map { |o| o.extend_variables(*variables) }.freeze
    end

    def variables
      observations.first.variables
    end

    def index
      observations.map(&:index)
    end

    def type
      observations.first.type
    end

    def inspect
      "#<#{self.class.name}(#{type}): [#{variables.join(', ')}] x #{size}>"
    end

    def size
      observations.size
    end

    def first
      observations.first
    end

    def last
      observations.last
    end

    def [](idx)
      observations[idx]
    end

    def at(index)
      observations.detect { |o| o.index == index }
    end

    def today
      observations.first.index.is_a?(Date) or
        fail TypeError, "You can't use #today with non-Date index"

      at(Date.today)
    end

    def each(&block)
      return to_enum(:each) unless block

      @observations.each(&block)
    end
  end
end
