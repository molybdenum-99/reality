#!/usr/bin/env ruby

require_relative '_base'
require 'reality/data_sources/wikidata'

titles = ARGV.dup

source = Reality::DataSources::Wikidata.new

titles.each do |t|
  puts "#{t}\n" + "="*t.length + "\n"

  observations = t =~ /^Q\d+$/ ? source.id(t) : source.get(t)
  observations.each { |name, val| puts '%s: %p' % [name, val] }
end
