#!/usr/bin/env rake
# coding: utf-8

require 'rake/testtask'
require 'rdoc/task'

#Generate internal documentation with rdoc.
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"

  #List out all the files to be documented.
  rdoc.rdoc_files = ["lib/fOOrth.rb",
                     "lib/fOOrth/exceptions.rb",
                     "lib/fOOrth/core.rb",
                     "lib/fOOrth/interpreter.rb",
                     "lib/fOOrth/interpreter/data_stack.rb",
                     "lib/fOOrth/compiler.rb",
                     "lib/fOOrth/main.rb",
                     "license.txt",
                     "README.txt"]

  #Make all access levels visible.
  rdoc.options << '--visibility' << 'private'
end

#Run the fOOrth test suite.
Rake::TestTask.new do |t|
  #List out all the test files.
  t.test_files = []

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
