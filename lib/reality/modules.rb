module Reality
  module Modules
    module_function

    def list
      @list ||= []
    end

    def include_into(entity)
      return if @disabled
      list
        .select { |block, mod| entity.instance_eval(&block) }
        .map(&:last).each(&entity.method(:extend))
    end

    def disable!
      @disabled = true
    end

    def register(mod, &block)
      Modules.list << [block, mod]
    end
  end

  require_ %w[modules/*]
end
