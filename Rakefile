require 'bundler/setup'
require 'rubygems/tasks'
Gem::Tasks.new

namespace :doc do
  desc "Prints TOC for README.md (doesn't inserts it automatically!)"
  task :toc do
    # NB: really dumb. Yet better than any Solution I can find :(

    File.readlines('README.md').
      map(&:chomp).grep(/\#{2,}\s*/).
      each do |ln|
        level, text = ln.scan(/^(\#{2,})\s*(.+)$/).flatten
        next if text == 'Table Of Contents'

        link = text.downcase.
          gsub(/[\/]/, '').
          gsub(/[.?, ]/, '-').gsub(/-{2,}/, '-').
          gsub(/^-|-$/, '')
        
        puts '%s* [%s](#%s)' %
          [
            '  ' * (level.count('#') - 2),
            text,
            link
          ]
      end
  end
end
