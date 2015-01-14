# coding: utf-8

#This file contains a minimum host environment for running the fOOrth system.

begin
  require 'fOOrth'
rescue LoadError => e
  require './lib/fOOrth'
end

XfOOrth::main
