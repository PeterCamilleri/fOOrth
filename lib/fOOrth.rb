# coding: utf-8

# The foorth Language System implemented via a Ruby gem.

require_relative 'foorth/exceptions'
require_relative 'foorth/monkey_patch'
require_relative 'foorth/symbol_map'
require_relative 'foorth/core'
require_relative 'foorth/interpreter'
require_relative 'foorth/compiler'
require_relative 'foorth/main'

#\Xfoorth - the module name space of the foorth language system.
#* foorth.rb - The root file that gathers up all the system's parts.
module Xfoorth

  #The version of this module.
  #<br>Returns
  #* A version string; <major>.<minor>.<step>
  def self.version
    "00.06.00"
  end

  #\VirtualMachine - the heart of the foorth language system.
  class VirtualMachine

    #Set true for verbose compiler play-by-plays and detailed error reports.
    attr_accessor :debug

    #The descriptive name of this virtual machine.
    attr_reader :name

    #Create an new instance of a foorth virtual machine
    #<br>Parameters:
    #* name - An optional string that describes this virtual machine instance.
    def initialize(name='-')
      @name = name

      #Bring the major sub-systems to a known state.
      interpreter_reset
      compiler_reset

      #This virtual machine is associated with this thread.
      Thread.current[:vm] = self
    end

  end

end
