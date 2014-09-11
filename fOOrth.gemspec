#Specify the building of the fOOrth gem.

Gem::Specification.new do |s|
  s.name = "fOOrth"
  s.summary = "FNF == fOOrth is Not FORTH."
  s.description = "An Object Oriented ~FORTH~ language gem."
  s.version = '0.6.0'
  s.author = ["Peter Camilleri"]
  s.email = "peter.c.camilleri@gmail.com"
  s.homepage = "http://teuthida-technologies.com/"
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>=1.9.3'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'reek'
  s.add_development_dependency 'minitest'

  #s.add_runtime_dependency 'in_array'

  s.files  = ['lib/fOOrth.rb']
  s.files += Dir['lib/fOOrth/*.rb']
  s.files += Dir['lib/fOOrth/monkey_patch/*.rb']
  s.files += Dir['lib/fOOrth/core/*.rb']
  s.files += Dir['lib/fOOrth/interpreter/*.rb']
  s.files += Dir['lib/fOOrth/compiler/*.rb']

  s.files += Dir['tests/*.rb']

  s.files += ['rakefile.rb',
              'sire.rb',
              'license.txt',
              'readme.txt',
              'reek.txt']

  s.extra_rdoc_files = ['license.txt']

  s.test_files  = Dir['tests/*.rb']
  s.test_files += Dir['tests/monkey_patch/*.rb']

  s.license = 'MIT'
  s.has_rdoc = true
  s.require_path = 'lib'
end
