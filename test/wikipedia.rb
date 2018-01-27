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

if titles.first == 'q'
  query = titles[1..-1].each_cons(2).to_h.transform_keys(&:to_sym)
  pp source.query(query)
else
  titles.each do |t|
    entity = source.get(t)

    puts "#{t}\n" + "="*t.length + "\n"
    #observations.each(&method(:puts))
    puts entity.describe
  end
end
