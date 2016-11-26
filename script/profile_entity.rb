require 'bundler/setup'
require 'reality'
require 'ruby-prof'


RubyProf.start
Reality::Entity('Kyiv')

result = RubyProf.stop

printer = RubyProf::GraphHtmlPrinter.new(result)
printer.print(File.open('tmp/profile-kyiv.html', 'w'))
