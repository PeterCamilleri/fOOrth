# coding: utf-8

#This file contains a minimum host environment for running the fOOrth system.

begin
  require 'fOOrth'
  puts "\nRunning demo from system gem."
rescue LoadError
  require './lib/fOOrth'
  puts "\nRunning demo from local code folder."
end

puts
XfOOrth::main
