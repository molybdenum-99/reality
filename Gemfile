source 'https://rubygems.org'

gem 'infoboxer', github: 'molybdenum-99/infoboxer', branch: 'develop'

gemspec

group :docs do
  gem 'yard'
  gem 'dokaz', git: 'https://github.com/zverok/dokaz.git'
end

group :development do
  gem 'progress_bar', git: 'git://github.com/zverok/progress_bar'

  gem 'nokogiri'
  gem 'addressable'
  gem 'naught'
  gem 'faraday'
  gem 'faraday_middleware'
  #gem 'progress_bar'
  gem 'rake'
  gem 'rubygems-tasks'
end

group :test do
  gem 'rspec', '~> 3'
  gem 'rspec-its', '~> 1'
  gem 'vcr'
  gem 'webmock'
end
