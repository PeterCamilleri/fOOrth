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
    "00.06.00"
  end

end

