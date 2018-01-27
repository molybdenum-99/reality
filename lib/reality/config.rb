module Reality
  class Config
    attr_reader :keys, :data

    def initialize
      @keys = {}
      @data = {}.extend Hashie::Extensions::DeepFetch
    end

    def load(str)
      if File.exists?(str)
        str = File.read(str)
      end

      @data.update(YAML.load(str))
    end

    def fetch(*path)
      data.deep_fetch(*path){
        if (known = @keys[path])
          fail KeyError, "Expected #{path.join('.')} to exist in config. It is #{known[:desc]}"
        else
          fail KeyError, "Expected #{path.join('.')} to exist in config."
        end
      }
    end

    def register(*path, **opts)
      @keys[path] = opts
    end
  end

  # @private
  def Reality.config
    @config ||= Config.new
  end

  # Allows to configure Reality.
  #
  # @param path [String] Path to config. See `config/demo.yml` for config
  #   sample. Also, you can use `:demo` value for config Reality with
  #   demo keys.
  #
  def Reality.configure(path)
    if path == :demo
      config.load(File.expand_path('../../../config/demo.yml', __FILE__))
    else
      config.load(path)
    end
  end
end
