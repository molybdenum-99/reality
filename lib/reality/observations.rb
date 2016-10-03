require 'forwardable'

module Reality
  using Reality::Refinements

  class Observations
    extend Forwardable

    attr_reader :observations

    def self.from_hashes(hashes)
      new(*hashes.map(&Observation.method(:new)))
    end

    def initialize(*observations)
      validate(observations)

      variables = observations.map(&:variables).flatten.uniq
      @observations = observations
        .map { |o| o.extend_variables(*variables) }.freeze
    end

    def_delegators :observations, :first, :last, :size, :each, :[]
    def_delegators :first, :type, :variables

    def index
      observations.map(&:index)
    end

    def inspect
      "#<#{self.class.name}(#{type}): [#{variables.join(', ')}] x #{size}>"
    end

    def at(index)
      observations.detect { |o| o.index == index }
    end

    def today
      observations.first.index.is_a?(Date) or
        fail TypeError, "You can't use #today with non-Date index"

      at(Date.today)
    end

    private

    def validate(observations)
      observations.map(&:type).uniq.tap { |types|
        types.size == 1 or raise(ArgumentError, "Observations have different types: #{types.join(', ')}")
      }
      observations.map(&:index).map(&:class).uniq.tap { |classes|
        classes.size == 1 or raise(ArgumentError, "Observations have different index classes: #{classes.join(', ')}")
      }
      observations.map(&:index).group_by(&:itself).select { |i, g| g.count > 1 }.tap { |groups|
        groups.empty? or raise(ArgumentError, "Observations have non-unique indexes: #{groups.keys.join(', ')}")
      }
    end
  end
end
