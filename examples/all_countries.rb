#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
$:.unshift 'lib'
require 'reality'
require 'fileutils'
require 'yaml'

FileUtils.mkdir_p 'examples/output'

File.write 'examples/output/countries.yaml',
  Reality.countries.sort_by(&:name).map(&:to_h).to_yaml
