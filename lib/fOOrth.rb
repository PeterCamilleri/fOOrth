# coding: utf-8

# The fOOrth Language System implemented via a Ruby gem.

require          'safe_clone'
require          'full_clone'
require          'in_array'
require          'format_engine'
require          'English'

require_relative 'fOOrth/version'
require_relative 'fOOrth/debug'
require_relative 'fOOrth/monkey_patch'
require_relative 'fOOrth/symbol_map'
require_relative 'fOOrth/interpreter'
require_relative 'fOOrth/compiler'
require_relative 'fOOrth/initialize'
require_relative 'fOOrth/core'

unless $exclude_fOOrth_library
  require_relative 'fOOrth/library'
  require_relative 'fOOrth/main'
end

#\XfOOrth - the module name space of the fOOrth language system.
#* fOOrth.rb - The root file that gathers up all the system's parts.
module XfOOrth

  #The version of this module.
  #<br>Returns
  #* A version string; <major>.<minor>.<step>
  def self.version
    VERSION
  end

  #The virtual machine is the heart of the fOOrth language system that is
  #used to facilitate the stack oriented processing of data and language
  #elements.
  #* fOOrth.rb - Version info lives here.
  class VirtualMachine

    #Get the version string for this virtual machine.
    #<br>Endemic Code Smells
    #* :reek:UtilityFunction
    def version
      XfOOrth.version
    end
  end

end

