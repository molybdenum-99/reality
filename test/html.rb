require 'bundler/setup'
require 'reality'
require 'reality/iruby'
require 'fileutils'

PRE = %Q{
<html>
<head>
  <meta charset="utf-8">
</head>
<body>
}

POST = %Q{
</body>
</html>
}

e = Reality::Entity('Argentina')
FileUtils.mkdir_p('test/output')
File.write 'test/output/argentina.html', PRE + e.to_html + POST

l = Reality::List('Argentina', 'Bolivia', 'Chile')

FileUtils.mkdir_p('test/output')
File.write 'test/output/compare.html', PRE + l.compare.to_html + POST
