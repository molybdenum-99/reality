module Reality
  module Util
    # Description is just a String subclass with rewritten `inspect`
    # implementation (useful in `irb`/`pry`).
    #
    class Description < String
      alias_method :inspect, :to_s

      def initialize(str)
        super(str.to_s.gsub(/ +\n/, "\n"))
      end

      # @private
      def indent(indentation = '  ')
        gsub(/(\A|\n)/, '\1' + indentation)
      end

      # @private
      def +(other)
        self.class.new(super)
      end
    end
  end
end
