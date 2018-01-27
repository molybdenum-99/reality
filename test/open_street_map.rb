#!/usr/bin/env ruby

require 'bundler/setup'
$LOAD_PATH.unshift 'lib'
require 'reality'
require 'reality/describers/open_street_map'
require 'pp'

title = ARGV.first

id = if title =~ /^(node|way|rel):(\d+)$/
  title
else
  wikidata = Reality::DataSources::Wikidata::Impl::Api.new(user_agent: Reality::USER_AGENT)
  osm_id = wikidata
    .wbgetentities.titles(title).sites(:enwiki)
    .props(:info, :sitelinks, :claims).sitefilter(:enwiki).languages(:en)
    .response['entities'].values.first['claims']['P402'].first['mainsnak']['datavalue']['value']
  "rel:#{osm_id}"
end

source = Reality::DataSources::OpenStreetMap.new

puts "#{title}\n" + "="*title.length + "\n"

observations = source.get(id)
observations.each { |name, val| puts '%s: %p' % [name, val] }
