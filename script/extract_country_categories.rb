#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'infoboxer'
require 'yaml'

countries = Infoboxer.wp.
  get('List of countries by continent').
  sections.first.
  sections.tables.lookup(:Wikilink, :bold?).
  reject{|l| l.link == 'India'}. # as of 28.12, India page is broken
  follow

File.write 'script/out/categories.txt',
  countries.categories.map(&:link).group_by(&:itself).sort.
    map{|cat, group| "#{cat}: #{group.count}"}.join("\n")
