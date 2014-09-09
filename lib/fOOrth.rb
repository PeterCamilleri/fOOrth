# coding: utf-8

# The fOOrth Language System implemented via a Ruby gem.

require_relative 'fOOrth/interpreter'
require_relative 'fOOrth/compiler'
require_relative 'fOOrth/main'

#\XfOOrth - the module name space of the fOOrth language system.
#* fOOrth.rb - The root file that gathers up all the system's parts.
module XfOOrth

  #The version of this module.
  #<br>Returns
  #* A version string; <major>.<minor>.<step>
  def version
    "00.06.00"
  end

  #\VirtualMachine - the heart of the fOOrth language system.
  class VirtualMachine
    #The descriptive name of this virtual machine.
    attr_reader :name

    #Create an new instance of a fOOrth virtual machine
    #<br>Parameters:
    #* name - An optional string that describes this virtual machine instance.
    def initialize(name='----')
      @name = name

      #Bring the major sub-systems to a known state.
      interpreter_reset
      compiler_reset

      #This virtual machine is associated with this thread.
      Thread.current[:vm] = self
    end

  end

end