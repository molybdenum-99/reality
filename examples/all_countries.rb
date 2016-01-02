#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
$:.unshift 'lib'
require 'reality'
require 'fileutils'
require 'yaml'

FileUtils.mkdir_p 'examples/output'

start = Time.now

File.write 'examples/output/countries.yaml',
  Reality.countries.to_a.sort_by(&:name).map(&:to_h).to_yaml

puts "Finished in %i seconds" % (Time.now - start)
