lib = 'jsondoc'
lib_file = File.expand_path("../lib/#{lib}.rb", __FILE__)
File.read(lib_file) =~ /\bVERSION\s*=\s*["'](.+?)["']/
version = $1

Gem::Specification.new do |s|
  s.name        = 'jsondoc'
  s.version     = version
  s.date        = '2016-08-23'
  s.summary     = 'JsonDoc'
  s.description = 'A base document object'
  s.authors     = ['John Wang']
  s.email       = 'johncwang@gmail.com'
  s.homepage    = 'https://github.com/grokify/'
  s.licenses    = ['MIT']
  s.files       = Dir['lib/**/**/*'] + Dir['test/**/*'] \
                + Dir['[A-Z]*'].grep(/^[A-Z]/).select {|s|/Gemfile\.lock/ !~ s}
end
