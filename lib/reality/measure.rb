module Reality
  # Wrapper for numeric values.
  # Example:
  #   Reality::Entity.new('Ukraine', load: true).area
  #    => #<Reality::Measure(603,500 km²)>
  # Keeps information about value unit
  # Allows coercion and general Numeric operations
  class Measure
    %w[unit].each{|mod| require_relative "measure/#{mod}"}

    attr_reader :amount, :unit

    def Measure.coerce(amount, unit)
      amount && unit && new(amount, unit)
    end

    def Measure.classes
      @classes ||= Hash.new { |h, unit|
        h[unit] = Class.new(self) {
          define_singleton_method(:inspect) { "Reality::Measure[#{unit}]" }
          define_method(:initialize) { |amount| super(amount, unit) }
        }
      }
    end

    def Measure.[](unit)
      classes[unit.to_s]
    end

    def Measure.to_proc
      method(:new)
    end

    # @param amount - numeric value, e.g. 100.5
    # @param unit - can be any string, e.g. 'km', '$'
    def initialize(amount, unit)
      @amount, @unit = Rational(amount), Unit.parse(unit)
    end

    def <=>(other)
      return nil unless compatible?(other)

      amount <=> other.amount
    end

    def -@
      self.class.new(-amount, unit)
    end

    def +(other)
      check_compatibility!(other)

      self.class.new(amount + other.amount, unit)
    end

    def -(other)
      self + (-other)
    end

    def *(other)
      case other
      when Numeric
        self.class.new(amount * other, unit)
      when self.class
        self.class.new(amount * other.amount, unit * other.unit)
      else
        fail ArgumentError, "Can't multiply by #{other.class}"
      end
    end

    def /(other)
      case other
      when Numeric
        self.class.new(amount / other, unit)
      when Measure
        un = unit / other.unit
        un.scalar? ?
          amount / other.amount :
          Measure[un].new(amount / other.amount)
      else
        fail ArgumentError, "Can't divide by #{other.class}"
      end
    end

    def **(num)
      (num-1).times.inject(self){|res| res*self}
    end

    def abs
      self.class.new(amount.abs, unit)
    end

    include Comparable

    def to_s
      '%s%s' % [Util::Format.number(amount), unit]
    end

    def to_h
      {amount: amount.to_f, unit: unit.to_s}
    end

    def to_f
      amount.to_f
    end

    def to_i
      amount.to_i
    end

    def inspect
      "#<Reality::Measure %s %s>" % [Util::Format.number(amount), unit]
    end

    private

    def check_compatibility!(other)
      compatible?(other) or fail ArgumentError, "#{self} incompatible with #{other}"
    end

    def compatible?(other)
      other.kind_of?(self.class) && other.unit == unit
    end
  end
end
