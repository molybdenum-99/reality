require 'strscan'

module Reality
  class Measure
    class Unit
      @unicode = true
      
      class << self
        attr_accessor :unicode

        UNIT_REGEX = /[^\s\+\*\/\/\^²³·]+/
        POWER_REGEX = /[²³]|\^(\d+)/
        OP_REGEX = /[\/*·]/

        def parse(str)
          return str if str.kind_of?(Unit)
          
          scanner = StringScanner.new(str)
          denom = false
          units = []
          
          loop do
            # (variable [power] operator) ....
            unit = scanner.scan(UNIT_REGEX) or fail("Variable expected at #{scanner.rest}")
            pow = scanner.scan(POWER_REGEX)
            units << [unit, parse_pow(pow, denom)]
            break if scanner.eos?

            op = scanner.scan(OP_REGEX) or fail("Operator expected at #{scanner.rest}")
            if op == '/'
              denom and fail("Second division at #{scanner.rest}")
              denom = true
            end
          end
          new(*units)
        end

        def parse_pow(p, denom)
          res = case p
          when nil then 1
          when '²' then 2
          when '³' then 3
          when /^\^(\d+)$/ then $1.to_i
          else fail(ArgumentError, "Can't parse power #{p}")
          end

          denom ? -res : res
        end
      end
      
      attr_reader :components
      
      def initialize(*components)
        @components = components.
          group_by{|sig, pow| sig}.
          map{|sig, cmps| [sig, cmps.map(&:last).inject(:+)]}.
          reject{|sig, pow| pow.zero?}
      end

      def ==(other)
        other.class == self.class && other.components == self.components
      end

      def scalar?
        components.empty?
      end

      def -@
        self.class.new(*components.map{|sig, pow| [sig, -pow]})
      end

      def *(other)
        other.class == self.class or
          fail(TypeError, "Can't multiply #{self.class} by #{other.class}")

        self.class.new(*components, *other.components)
      end

      def /(other)
        other.class == self.class or
          fail(TypeError, "Can't divide #{self.class} by #{other.class}")

        self * -other
      end

      def to_s
        num, denom = components.partition{|sig, pow| pow > 0}
        numerator = num.map{|sig, pow| "#{sig}#{power(pow)}"}.join(mul)
        denominator = denom.map{|sig, pow| "#{sig}#{power(pow)}"}.join(mul)
        case
        when numerator.empty?
          [1, denominator].join('/')
        when denominator.empty?
          numerator
        else
          [numerator, denominator].join('/')
        end
      end

      def inspect
        "#<#{self.class}(#{to_s})>"
      end

      private

      UNICODE_SUPER = {2 => '²', 3 => '³'}

      def mul
        self.class.unicode ? '·' : '*'
      end

      def power(num)
        num = num.abs
        case num
          when 0 then fail(ArgumentError, "0-power unit!")
          when 1 then ''
          when 2..3
            self.class.unicode ? UNICODE_SUPER.fetch(num) : "^#{num}"
          else "^#{num}"
        end
      end
    end
  end
end
