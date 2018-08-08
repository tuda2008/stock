require 'find'
require 'rubygems'
 
Find.find(File.join('public', 'assets')) do |path|
  if File.extname(path) == '.js'
  	puts path
    files = File.basename(path).split("-")
  	system "mv #{path} #{File.dirname(path)}/#{files[0] + '.self-' + files[1]}"
  end
end