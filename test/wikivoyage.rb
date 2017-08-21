#!/usr/bin/env ruby

require 'bundler/setup'
$LOAD_PATH.unshift 'lib'
require 'reality'
require 'reality/data_sources/wikivoyage'

titles = ARGV.dup

source = Reality::DataSources::Wikivoyage.new

titles.each do |t|
  puts "#{t}\n" + "="*t.length + "\n"

  observations = source.get(t)
  observations.each { |name, val| puts '%s: %p' % [name, val] }
end
