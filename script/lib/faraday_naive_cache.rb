require 'addressable/uri'
require 'json'

module Faraday
  class NaiveCache < Middleware
    BASE_PATH = 'tmp/cache' # FIXME, obviously
    
    def call(env)
      if response = from_cache(env[:url])
        env[:response] = response
      else
        @app.call(env).on_complete do |env|
          to_cache(env[:url], env)
        end
      end
    end

    private

    def from_cache(url)
      path = cached_path(url)
      File.exists?(path) ? Response.new(JSON.parse(File.read(path))) : nil
    end

    def to_cache(url, env)
      env.body = env.body.force_encoding('UTF-8')
      
      path = cached_path(url)
      FileUtils.mkdir_p File.dirname(path)
      File.write path, env.to_hash.to_json
    end

    def cached_path(url)
      uri = Addressable::URI.parse(url)
      filename = [uri.path, uri.query].compact.join('?').gsub(/[?\/&]/, '-')
      filename = '_root_' if filename.empty?
      File.join(BASE_PATH, uri.host, filename)
    end
  end
end
