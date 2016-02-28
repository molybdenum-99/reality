require 'hashie'

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

  def Reality.config
    @config ||= Config.new
  end

  def Reality.configure(cfg)
    if cfg == :demo
      config.load(File.expand_path('../../../config/demo.yml', __FILE__))
    else
      config.load(cfg)
    end
  end
end
