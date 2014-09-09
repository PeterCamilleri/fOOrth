#!/usr/bin/env rake
# coding: utf-8

require 'rake/testtask'
require 'rdoc/task'

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"

  #List out all the files to be documented.
  rdoc.rdoc_files = ["lib/fOOrth.rb",
                     "lib/fOOrth/core.rb",
                     "lib/fOOrth/interpreter.rb",
                     "lib/fOOrth/compiler.rb",
                     "lib/fOOrth/main.rb",
                     "license.txt", "README.txt"]

  #Make all access levels visible.
  rdoc.options << '--visibility' << 'private'
end

Rake::TestTask.new do |t|
  #List out all the test files.
  t.test_files = []

  t.verbose = false
end

task :reek do |t|
  `reek --no-color lib > reek.txt`
end

def eval_puts(str)
  puts str
  eval str
end

task :console do
  require 'irb'
  require 'irb/completion'
  require './lib/fOOrth'
  puts "Starting an IRB console for fOOrth."
  ARGV.clear
  IRB.start
end
