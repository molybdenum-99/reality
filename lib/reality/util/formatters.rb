module Reality
  module Util
    module Format
      module_function

      def number(n)
        case n.abs
        when 0..1
          n.to_f.to_s.sub(/(\.0+[1-9]).*$/, '\1')
        when 1..4
          ('%.2f' % n).sub(/\.?0+$/, '')
        when 1_000..Float::INFINITY
          # see http://stackoverflow.com/a/6460145/3683228
          n.to_i.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
        else
          n.to_i.to_s
        end
      end
    end
  end
end
