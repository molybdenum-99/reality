module Reality
  # @private
  module Util
    module Parse
      module_function

      def scaled_number(str)
        match, amount, scale = */^([0-9.,]+)[[:space:]]*(#{SCALES_REGEXP})?/.match(str)
        match or return nil

        if scale
          number(amount) * fetch_scale(scale)
        else
          number(amount)
        end
      end

      def number(str)
        str = str.gsub(',', '').tr('−', '-')
        case str
        when /^-?\d+$/
          str.to_i
        when /^-?\d+\.\d+$/
          str.to_f
        else
          nil
        end
      end

      private

      module_function

      # See "Short scale": https://en.wikipedia.org/wiki/Long_and_short_scales#Comparison
      SCALES = {
        'million'     => 1_000_000,
        'billion'     => 1_000_000_000,
        'trillion'    => 1_000_000_000_000,
        'quadrillion' => 1_000_000_000_000_000,
        'quintillion' => 1_000_000_000_000_000_000,
        'sextillion'  => 1_000_000_000_000_000_000_000,
        'septillion'  => 1_000_000_000_000_000_000_000_000,
      }
      SCALES_REGEXP = Regexp.union(*SCALES.keys)

      def fetch_scale(str)
        _, res = SCALES.detect{|key, val| str.start_with?(key)}

        res or fail("Scale not found: #{str} for #{self}")
      end
      
    end
  end
end
