$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'binascii/version'

Gem::Specification.new do |s|
  s.name     = 'binascii'
  s.version  = ::Binascii::VERSION
  s.authors  = ['Cameron Dutro']
  s.email    = ['camertron@gmail.com']
  s.homepage = 'https://github.com/camertron/binascii'
  s.license  = 'MIT'
  s.description = s.summary = "A Ruby version of Python's binascii module"

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.require_path = 'lib'
  s.files = Dir['{lib,spec}/**/*', 'Gemfile', 'CHANGELOG.md', 'README.md', 'Rakefile', 'binascii.gemspec']
end
