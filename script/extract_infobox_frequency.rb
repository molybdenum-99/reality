require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'progress_bar'
require 'faraday'
require_relative 'lib/faraday_naive_cache'

client = Faraday.new('https://tools.wmflabs.org/templatecount/') do |builder|
  builder.use Faraday::NaiveCache
  builder.adapter Faraday.default_adapter
end

links = File.read('data/infoboxes.txt').split("\n").
  reject{|l| l.include?('/')}.
  map{|l| l.sub('Template:', '')}

bar = ProgressBar.new(links.count)

out = File.open('data/infoboxes_freq.txt', 'w')

links.each do |l|
  u = "index.php?lang=en&name=%s" % URI.escape(l.gsub(' ', '_'))
  doc = Nokogiri::HTML(client.get(u).body)
  t = doc.search('h3').detect{|h| h.text == 'Number of transclusions'}.next_element.text.to_i
  out.puts "#{l}: #{t}"
  bar.increment!
end
