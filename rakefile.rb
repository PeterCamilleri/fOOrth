#!/usr/bin/env rake
# coding: utf-8

require 'rake/testtask'
require 'rdoc/task'
require "bundler/gem_tasks"

#Generate internal documentation with rdoc.
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"

  #List out all the files to be documented.
  rdoc.rdoc_files.include("lib/**/*.rb", "license.txt", "README.md")

  #Make all access levels visible.
  rdoc.options << '--visibility' << 'private'
  #rdoc.options << '--verbose'
  #rdoc.options << '--coverage-report'

  #Set a title.
  rdoc.options << '--title' << 'fOOrth Language Internals'

end

#Run the fOOrth unit test suite.
Rake::TestTask.new do |t|
  #List out all the unit test files.
  t.test_files = FileList['tests/**/*.rb']
  t.verbose = false
  t.warning = true
end

#Run the fOOrth integration test suite.
Rake::TestTask.new(:integration) do |t|
  #List out all the integration test files.
  t.test_files = FileList['integration/*.rb']
  t.verbose = false
  t.warning = false
end

desc "Run a scan for smelly code!"
task :reek do |t|
  `reek --no-color lib > reek.txt`
end

desc "Fire up an IRB session with fOOrth preloaded."
task :console do
  system "ruby irbt.rb local"
end

desc "Run an Interactive fOOrth Session."
task :run do
  require './lib/fOOrth'
  ARGV.clear
  XfOOrth::main
end

desc "What version of fOOrth is this?"
task :vers do |t|
  puts
  puts "fOOrth version = #{XfOOrth::VERSION}"
end

