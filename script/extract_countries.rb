#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'infoboxer'
require 'yaml'

File.write 'data/countries.yaml',
  Infoboxer.wp.get('List of countries').
    tables.first.
    templates(name: 'flag').fetch('1').
    map(&:text).uniq.sort.
    to_yaml
