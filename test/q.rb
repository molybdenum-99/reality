#!/usr/bin/env ruby

require 'bundler/setup'
$LOAD_PATH.unshift 'lib'
require 'reality'

args = ARGV.dup

describer, link = args.shift.split('://')
source = Reality.describers.fetch(describer)

if link == '?'
  query = args.each_slice(2).to_h
  response = source.query(query).load
  if response.all?(Reality::Entity)
    response.map(&:describe).each(&method(:puts))
  else
    pp response
  end
else
  entity = source.get(link)
  while !args.empty? && entity.is_a?(Reality::Entity)
    entity = entity[args.shift]
    entity = entity.load if entity.is_a?(Reality::Link)
  end

  puts entity.is_a?(Reality::Entity) ? entity.describe : entity.inspect
end
