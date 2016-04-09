require 'bundler/setup'
require 'rubygems/tasks'
Gem::Tasks.new

namespace :doc do
  desc "Prints TOC for README.md (doesn't inserts it automatically!)"
  task :toc do
    # NB: really dumb. Yet better than any Solution I can find :(

    puts '## Table Of Contents'
    puts
    
    File.readlines('README.md').
      map(&:chomp).grep(/\#{2,}\s*/).
      each do |ln|
        level, text = ln.scan(/^(\#{2,})\s*(.+)$/).flatten
        puts '  ' * (level.count('#') - 2) + '* ' + text
      end
  end
end
