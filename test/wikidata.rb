#!/usr/bin/env ruby

require_relative '_base'
require 'reality'

titles = ARGV.dup

source = Reality::Describers::Wikidata.new

titles.each do |t|
  #observations = t =~ /^Q\d+$/ ? source.id(t) : source.get(t)
  #observations.each { |name, val| puts '%s: %p' % [name, val] }

  entity = source.get(t)

  puts "#{t}\n" + "="*t.length + "\n"
  #observations.each(&method(:puts))
  puts entity.describe
end
