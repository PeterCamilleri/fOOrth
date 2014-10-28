# coding: utf-8

#* core/core_access.rb - An accessor module for the OO core of fOOrth.
module CoreAccess

  #A short-cut for getting the hash of all fOOrth classes.
  attr_reader :all_classes

  #A short-cut for getting the fOOrth Object class.
  attr_reader :object_class

  #A short-cut for getting the fOOrth Class class.
  attr_reader :class_class

  #Get the spec that corresponds to this symbol in the Object shared dictionary.
  def object_maps_symbol(symbol)
    object_class.map_foorth_shared(symbol)
  end

  #Get the spec that corresponds to this name in the Object shared dictionary.
  def object_maps_name(name)
    (symbol = SymbolMap.map(name)) && object_maps_symbol(symbol)
  end

  #There is no short cut for getting the fOOrth VitualMachine class because
  #it also happens to be the Ruby VirtualMachine class.

  #A short-cut for getting the virtual machine of the current thread.
  def virtual_machine
    Thread.current[:vm]
  end

end
