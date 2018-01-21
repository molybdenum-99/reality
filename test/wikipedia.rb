#!/usr/bin/env ruby

require 'bundler/setup'
$LOAD_PATH.unshift 'lib'
require 'reality'
require 'reality/data_sources/wikipedia'

titles = ARGV.dup

source = Reality::DataSources::Wikipedia.new
source.log.level = Logger::DEBUG

titles.each do |t|
  observations = source.get(t)

  puts "#{t}\n" + "="*t.length + "\n"
  observations.compact.each { |name, val| puts '%s: %p' % [name, val] }
end
