module Reality
  module Util
    module Format
      module_function

      # Redefine Reality's "pretty" formatter to "precise" one
      def number(n)
        n.to_f
      end
    end
  end
end
