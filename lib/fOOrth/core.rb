# coding: utf-8

require_relative 'compiler/word_specs'
require_relative 'core/object'
require_relative 'core/class'
require_relative 'core/virtual_machine'

#* core.rb - The fOOrth language OO core.
module XfOOrth

  $FOORTH_GLOBALS = Hash.new
  Object.create_foorth_proxy
  Class.create_foorth_proxy
  VirtualMachine.create_foorth_proxy

  #Predefine the default implementation of the .init method. This method must
  #exist at this point in order to proceed further.
  name = '.init'
  sym = SymbolMap.add_entry(name, :foorth_init)
  Object.create_shared_method(name, TosSpec, [], &lambda {|vm| })

  #Create a virtual machine instance for the main thread. The constructor
  #connects the new instance to a thread variable so we don't need to do
  #anything with it here.
  VirtualMachine.new('Main')

end
