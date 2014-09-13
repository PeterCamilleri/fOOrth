#!/usr/bin/env rake
# coding: utf-8

require 'rake/testtask'
require 'rdoc/task'

#Generate internal documentation with rdoc.
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"

  #List out all the files to be documented.
  rdoc.rdoc_files = ["lib/foorth.rb",
                     "lib/foorth/exceptions.rb",
                     "lib/foorth/display_abort.rb",
                     "lib/foorth/symbol_map.rb",
                     "lib/foorth/core.rb",
                     "lib/foorth/core/object.rb",
                     "lib/foorth/core/class.rb",
                     "lib/foorth/interpreter.rb",
                     "lib/foorth/interpreter/data_stack.rb",
                     "lib/foorth/interpreter/ctrl_stack.rb",
                     "lib/foorth/compiler.rb",
                     "lib/foorth/main.rb",
                     "lib/foorth/monkey_patch/object.rb",
                     "lib/foorth/monkey_patch/numeric.rb",
                     "lib/foorth/monkey_patch/rational.rb",
                     "lib/foorth/monkey_patch/complex.rb",
                     "lib/foorth/monkey_patch/string.rb",
                     "license.txt",
                     "README.txt"]

  #Make all access levels visible.
  rdoc.options << '--visibility' << 'private'
end

#Run the foorth test suite.
Rake::TestTask.new do |t|
  #List out all the test files.
  t.test_files = ["tests/monkey_patch/object_test.rb",
                  "tests/monkey_patch/rational_test.rb",
                  "tests/monkey_patch/numeric_test.rb",
                  "tests/monkey_patch/complex_test.rb",
                  "tests/monkey_patch/string_test.rb",
                  "tests/interpreter/data_stack_tests.rb",
                  "tests/interpreter/ctrl_stack_tests.rb",
                  "tests/symbol_map_tests.rb",
                  "tests/core_tests.rb"
                 ]

  t.verbose = false
end

#Run a scan for smelly code!
task :reek do |t|
  `reek --no-color lib > reek.txt`
end

#Fire up an IRB session with foorth preloaded.
task :console do
  require 'irb'
  require 'irb/completion'
  require './lib/foorth'
  puts "Starting an IRB console for foorth."
  ARGV.clear
  IRB.start
end

#Run the Simple Interactive Ruby Environment.
task :sire do
  require './lib/foorth'
  require './sire'
  SIRE.new.run_sire
end

#Run an Interactive foorth Session.
task :run do
  require './lib/foorth'
  ARGV.clear
  Xfoorth::main
end
