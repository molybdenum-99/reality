module Reality
  class Currency < Money::Currency
    module Methods
      def rate_to(other)
        Money.default_bank.get_rate(self, other)
      end

      def inspect
        "#<Reality::Currency #{name} (#{symbol}, #{iso_code})>"
      end
    end
    # Money::Currency have pretty tricky initializer
    def self.new(id)
      super(id).extend(Methods)
    end
  end
end
