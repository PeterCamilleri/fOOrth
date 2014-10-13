# coding: utf-8

# The fOOrth Language System implemented via a Ruby gem.

require_relative 'fOOrth/exceptions'
require_relative 'fOOrth/display_abort'
require_relative 'fOOrth/monkey_patch'
require_relative 'fOOrth/symbol_map'
require_relative 'fOOrth/interpreter'
require_relative 'fOOrth/compiler'
require_relative 'fOOrth/initialize.rb'
require_relative 'fOOrth/core'
require_relative 'fOOrth/main'

#\XfOOrth - the module name space of the fOOrth language system.
#* fOOrth.rb - The root file that gathers up all the system's parts.
module XfOOrth

  #The version of this module.
  #<br>Returns
  #* A version string; <major>.<minor>.<step>
  def self.version
    "00.00.00"
  end

  #The virtual machine is the heart of the fOOrth language system that is
  #used to facilitate the stack oriented processing of data and language
  #elements.
  #* fOOrth.rb - Version info lives here.
  class VirtualMachine

    #Get the version string for this virtual machine.
    def version
      XfOOrth.version
    end
  end

end

