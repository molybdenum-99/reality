#!/usr/bin/env ruby

require 'bundler/setup'
$LOAD_PATH.unshift 'lib'
require 'reality'
require 'reality/describers/abstract/base'
require 'reality/describers/abstract/media_wiki'
require 'reality/describers/wikipedia'

titles = ARGV.dup

source = Reality::Describers::Wikipedia.new
source.log.level = Logger::DEBUG

titles.each do |t|
  observations = source.get(t)

  puts "#{t}\n" + "="*t.length + "\n"
  observations.compact.each { |name, val| puts '%s: %p' % [name, val] }
end
