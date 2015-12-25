#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'mediawiktory'

out = File.open('data/infoboxes.txt', 'w')

w = MediaWiktory::Client.new('https://en.wikipedia.org/w/api.php')
res = w.query.list(prefixsearch: {search: 'Template:Infobox ', limit: 100}).perform
out.puts res.raw.query.prefixsearch.map(&:title)
while res.continue?
  cont = res.raw.continue.psoffset
  p cont
  res = w.query.list(prefixsearch: {search: 'Template:Infobox ', limit: 100, offset: cont}).perform
  out.puts res.raw.query.prefixsearch.map(&:title)
end
