module Reality
  # This class is a wrapper for numeric values and keeps information about value unit
  # Allows coercion and general Numeric operations
  class Measure
    %w[unit].each{|mod| require_relative "measure/#{mod}"}
    
    attr_reader :amount, :unit

    def Measure.coerce(amount, unit)
      amount && unit && new(amount, unit)
    end
    
    def initialize(amount, unit)
      @amount, @unit = Rational(amount), Unit.parse(unit)
    end

    def <=>(other)
      check_compatibility!(other)
      
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
      when self.class
        un = unit / other.unit
        un.scalar? ?
          amount / other.amount :
          self.class.new(amount / other.amount, un)
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
      "#<%s(%s %s)>" % [self.class, Util::Format.number(amount), unit]
    end

    private

    def check_compatibility!(other)
      unless other.kind_of?(self.class) && other.unit == unit
        fail ArgumentError, "#{self} incompatible with #{other}"
      end
    end
  end

  def Reality.Measure(*arg)
    Measure.new(*arg)
  end
end
