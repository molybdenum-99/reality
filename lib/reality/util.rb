module Reality
  module Util
    module_function

    def oneify(val)
      return val unless val.is_a?(Array)
      val.size <= 1 ? val.first : val
    end

    DEFAULT_REQUIRE_EXPLANATION = 'Please install `%s` in order to use this functionality.'.freeze

    def require_optional(gem, explanation = nil)
      require gem
    rescue LoadError
      raise LoadError, explanation || DEFAULT_REQUIRE_EXPLANATION % gem
    end
  end
end
