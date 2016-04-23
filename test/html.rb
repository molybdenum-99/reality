require 'bundler/setup'
require 'reality'
require 'reality/iruby'
require 'fileutils'

PRE = %Q{
<html>
<body>
}

POST = %Q{
</body>
</html>
}

e = Reality::Entity('Argentina')
FileUtils.mkdir_p('test/output')
File.write 'test/output/argentina.html', PRE + e.to_html + POST
