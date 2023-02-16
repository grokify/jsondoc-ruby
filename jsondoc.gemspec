lib = 'jsondoc'
lib_file = File.expand_path("../lib/#{lib}.rb", __FILE__)
File.read(lib_file) =~ /\bVERSION\s*=\s*["'](.+?)["']/
version = $1

Gem::Specification.new do |s|
  s.name        = 'jsondoc'
  s.version     = version
  s.date        = '2023-02-15'
  s.summary     = 'JsonDoc'
  s.description = 'A base document object'
  s.authors     = ['John Wang']
  s.email       = 'johncwang@gmail.com'
  s.homepage    = 'https://github.com/grokify/jsondoc-ruby'
  s.licenses    = ['MIT']
  s.files       = Dir['lib/**/**/*'] + Dir['test/**/*'] \
                + Dir['[A-Z]*'].grep(/^[A-Z]/).select {|s|/Gemfile\.lock/ !~ s}

  s.required_ruby_version = '>= 2.0.0'
  s.add_development_dependency 'rake', '~> 13', '>= 13.0.6'
  s.add_development_dependency 'test-unit', '~> 3'
end
