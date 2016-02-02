#!/usr/bin/env ruby
require 'bundler/setup'
require 'open-uri'
require 'progress_bar/core_ext/enumerable_with_progress'
require 'nokogiri'
require 'json'
require_relative 'lib/nokogiri_more'

start = Nokogiri::HTML(open('https://www.wikidata.org/wiki/Wikidata:List_of_properties'))
res = start.
      search('th:contains("By number")').first.parent.search('td > a').
      with_progress.map{|a|
        name = a.text
        data = Nokogiri::HTML(open('https://www.wikidata.org' + a.href).read).
                search('tr').
                map{|tr| tr.search('td').map(&:text)}.
                map{|tds| [tds[0], tds[1]]}.
                map(&:reverse).
                reject{|id, name| id.nil? || name.nil?}.
                to_h
      }.inject(&:merge)

File.write 'data/wikidata-predicates.json', res.to_json      
