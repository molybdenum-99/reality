module Reality
  module Refinements
    refine Object do
      def derp
        yield self
      end
    end
  end
end
