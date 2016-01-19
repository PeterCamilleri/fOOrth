# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fOOrth/version'

Gem::Specification.new do |spec|
  spec.name          = "fOOrth"
  spec.version       = XfOOrth::VERSION
  spec.authors       = ["Peter Camilleri"]
  spec.email         = "peter.c.camilleri@gmail.com"
  spec.homepage      = "http://teuthida-technologies.com/"
  spec.description   = "An Object Oriented FORTHesque language gem."
  spec.summary       = "FNF == fOOrth is Not FORTH."
  spec.license       = 'MIT'

  raw_list = `git ls-files`.split($/)
  raw_list = raw_list.keep_if {|entry| !entry.start_with?("docs") }

  spec.files         = raw_list
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.executables   = ["fOOrth"]

  spec.required_ruby_version = '>=1.9.3'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'reek', "~> 3.0"
  spec.add_development_dependency 'minitest', "~> 5.7"
  spec.add_development_dependency 'minitest_visible', "~> 0.0.2"
  spec.add_development_dependency 'rdoc', "~> 4.0.1"

  spec.add_runtime_dependency 'format_engine', "~> 0.2.0"
  spec.add_runtime_dependency 'full_clone'
  spec.add_runtime_dependency 'safe_clone'
  spec.add_runtime_dependency 'in_array'
  spec.add_runtime_dependency 'mini_readline', ">= 0.1.3"
end
