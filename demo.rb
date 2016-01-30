# coding: utf-8

#This file contains a minimum host environment for running the fOOrth system.

if ARGV[0] == 'local'
  require_relative 'lib/fOOrth'
  puts "\nOption(local) Loaded fOOrth from the local code folder."
elsif defined?(XfOOrth)
  puts "The fOOrth system is already loaded."
else
  begin
    require 'fOOrth'
    puts "\nLoaded fOOrth from the system gem."
  rescue LoadError
    require_relative 'lib/fOOrth'
    puts "\nLoaded fOOrth from the local code folder."
  end
end

puts

if __FILE__==$0
  XfOOrth::main
end
