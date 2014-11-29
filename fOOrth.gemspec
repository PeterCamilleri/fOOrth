# coding: utf-8

#Specify the building of the fOOrth gem.

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fOOrth/version'

Gem::Specification.new do |spec|
  spec.name = "fOOrth"
  spec.summary = "FNF == fOOrth is Not FORTH."
  spec.description = "An Object Oriented FORTHesque language gem."
  spec.version = XfOOrth::VERSION
  spec.author = ["Peter Camilleri"]
  spec.email = "peter.c.camilleri@gmail.com"
  spec.homepage = "http://teuthida-technologies.com/"
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>=1.9.3'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'reek', "~> 1.3.8"
  spec.add_development_dependency 'minitest', "~> 4.7.5"
  spec.add_development_dependency 'rdoc', "~> 4.0.1"

  spec.add_runtime_dependency 'full_clone'

  spec.files       = `git ls-files`.split($/)
  spec.test_files  = spec.files.grep(%r{^(test|spec|features)/})
  spec.extra_rdoc_files = ['license.txt']

  spec.license = 'MIT'
  spec.has_rdoc = true
  spec.require_paths = ["lib"]
end
