#!/usr/bin/env rake
# coding: utf-8

require 'rake/testtask'
require 'rdoc/task'

#Generate internal documentation with rdoc.
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"

  #List out all the files to be documented.
  rdoc.rdoc_files = ["lib/fOOrth.rb",
                     "lib/fOOrth/initialize.rb",
                     "lib/fOOrth/exceptions.rb",
                     "lib/fOOrth/display_abort.rb",
                     "lib/fOOrth/symbol_map.rb",
                     "lib/fOOrth/core.rb",
                     "lib/fOOrth/core/object.rb",
                     "lib/fOOrth/core/class.rb",
                     "lib/fOOrth/core/virtual_machine.rb",
                     "lib/fOOrth/interpreter.rb",
                     "lib/fOOrth/interpreter/data_stack.rb",
                     "lib/fOOrth/interpreter/ctrl_stack.rb",
                     "lib/fOOrth/compiler.rb",
                     "lib/fOOrth/compiler/read_point.rb",
                     "lib/fOOrth/compiler/console.rb",
                     "lib/fOOrth/compiler/source.rb",
                     "lib/fOOrth/compiler/string_source.rb",
                     "lib/fOOrth/compiler/file_source.rb",
                     "lib/fOOrth/compiler/process.rb",
                     "lib/fOOrth/compiler/parser.rb",
                     "lib/fOOrth/main.rb",
                     "lib/fOOrth/monkey_patch.rb",
                     "lib/fOOrth/monkey_patch/object.rb",
                     "lib/fOOrth/monkey_patch/numeric.rb",
                     "lib/fOOrth/monkey_patch/rational.rb",
                     "lib/fOOrth/monkey_patch/complex.rb",
                     "lib/fOOrth/monkey_patch/string.rb",
                     "license.txt",
                     "README.txt"]

  #Make all access levels visible.
  rdoc.options << '--visibility' << 'private'
end

#Run the fOOrth test suite.
Rake::TestTask.new do |t|
  #List out all the test files.
  t.test_files = ["tests/monkey_patch/object_test.rb",
                  "tests/monkey_patch/rational_test.rb",
                  "tests/monkey_patch/numeric_test.rb",
                  "tests/monkey_patch/complex_test.rb",
                  "tests/monkey_patch/string_test.rb",
                  "tests/interpreter/data_stack_tests.rb",
                  "tests/interpreter/ctrl_stack_tests.rb",
                  "tests/compiler/string_source_tests.rb",
                  "tests/compiler/file_source_tests.rb",
                  "tests/compiler/parser_tests.rb",
                  "tests/symbol_map_tests.rb",
                  "tests/core_tests.rb"
                 ]

  t.verbose = false
end

#Run a scan for smelly code!
task :reek do |t|
  `reek --no-color lib > reek.txt`
end

#Fire up an IRB session with fOOrth preloaded.
task :console do
  require 'irb'
  require 'irb/completion'
  require './lib/fOOrth'
  puts "Starting an IRB console for fOOrth."
  ARGV.clear
  IRB.start
end

#Run the Simple Interactive Ruby Environment.
task :sire do
  require './lib/fOOrth'
  require './sire'
  SIRE.new.run_sire
end

#Run an Interactive fOOrth Session.
task :run do
  require './lib/fOOrth'
  ARGV.clear
  XfOOrth::main
end
