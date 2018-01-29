#!/usr/bin/env ruby

require 'bundler/setup'
$LOAD_PATH.unshift 'lib'
require 'reality'
require 'reality/describers/wikimedia_commons'

source = Reality::Describers::WikimediaCommons.new

puts source.get(ARGV.first).describe
