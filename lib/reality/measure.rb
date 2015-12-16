module Reality
  class Measure
    attr_reader :amount, :unit
    
    def initialize(amount, unit)
      @amount, @unit = amount, unit
    end

    def <=>(other)
      check_compatibility!(other)
      
      amount <=> other.amount
    end

    include Comparable

    def to_s
      [amount, unit].join
    end

    def inspect
      "#<#{self.class}(#{amount} #{unit})>"
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
