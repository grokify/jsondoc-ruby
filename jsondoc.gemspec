lib = 'ringcentral_sdk'
lib_file = File.expand_path("../lib/#{lib}.rb", __FILE__)
File.read(lib_file) =~ /\bVERSION\s*=\s*["'](.+?)["']/
version = $1

Gem::Specification.new do |s|
  s.name        = 'jsondoc'
  s.version     = version
  s.date        = '2016-02-04'
  s.summary     = 'JsonDoc'
  s.description = 'A base document object'
  s.authors     = ['John Wang']
  s.email       = 'john@johnwang.com'
  s.files       = [
    'CHANGELOG.md',
    'LICENSE',
    'README.md',
    'Rakefile',
    'VERSION',
    'jsondoc.gemspec',
    'lib/jsondoc.rb',
    'lib/jsondoc/document.rb',
    'test/test_setup.rb'
  ]
  s.homepage    = 'http://johnwang.com/'
  s.license     = 'MIT'
end
