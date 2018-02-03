#!/usr/bin/env ruby
require 'bundler/setup'
require 'reality'
require 'pp'

# 1. sparql: "select all items of subclass <units of measurement>"

query = %{
PREFIX wikibase: <http://wikiba.se/ontology#>
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX wdt: <http://www.wikidata.org/prop/direct/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX p: <http://www.wikidata.org/prop/>
PREFIX v: <http://www.wikidata.org/prop/statement/>
PREFIX schema: <http://schema.org/>

SELECT ?item ?itemLabel
WHERE
{
  ?item wdt:P31/wdt:P279* wd:Q47574.
  SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
}
}

items = Faraday
  .get('https://query.wikidata.org/sparql', query: query, format: :json).body
  .yield_self(&JSON.method(:parse)).dig('results', 'bindings')
  .map { |bind| [bind.dig('item', 'value').match(/(Q\d+)/)[1], bind.dig('itemLabel', 'value')] }
  .reject { |id, name| id == name }

# File.write 'script/out/units.txt', res.map(&:last).sort.join("\n")

# TODO: In fact, this entire script should be "self-bootstrapped" by reality: that's what it is for,
# all in all. It is real goal, yet not achieved yet.


existing = Dir['script/out/units/*.yml'].map { |f| File.basename(f, '.yml') }
items.reject! { |id, _| existing.include?(id) }

api = Reality::Describers::Wikidata::Impl::Api.new(user_agent: Reality::USER_AGENT)
cache = Reality::Describers::Wikidata::LabelsCache.new(api)

items.each_slice(50).each_with_index { |chunk, i|
  puts "#{i * 50} of #{items.count}"
  api.wbgetentities.ids(*chunk.map(&:first))
    .props(:info, :sitelinks, :claims, :labels, :aliases).languages(:en)
    .response['entities']
    .each { |id, data|
      cache.update_from(data)
      File.write "script/out/units/#{id}.yml", data.to_yaml
    }
}
