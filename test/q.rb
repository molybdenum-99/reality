#!/usr/bin/env ruby

require 'bundler/setup'
$LOAD_PATH.unshift 'lib'
require 'reality'

args = ARGV.dup

describer, link = args.shift.split('://')
source = Reality.describers.fetch(describer)

if link == '?'
  query = args.each_slice(2).to_h
  pp source.query(query).load
else
  entity = source.get(link)

  puts entity.describe
end
