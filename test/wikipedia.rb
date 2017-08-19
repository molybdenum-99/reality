require 'bundler/setup'
$LOAD_PATH.unshift 'lib'
require 'reality'
require 'reality/data_sources/wikipedia'

titles = ARGV.dup

source = Reality::DataSources::Wikipedia.new

titles.each do |t|
  puts "#{t}\n" + "="*t.length + "\n"

  observations = source.get(t)
  observations.compact.each { |name, val| puts '%s: %p' % [name, val] }
end
