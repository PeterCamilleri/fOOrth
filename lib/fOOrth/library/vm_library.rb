# coding: utf-8

#* library/class_library.rb - The fOOrth Class class library.
module XfOOrth

  #Create a macro to get at the current virtual machine instance.
  # [] vm [the_current_vm]
  VirtualMachine.create_shared_method('vm', MacroSpec,
    [:macro, "vm.push(vm); "])


end
