# coding: utf-8

#* library/class_library.rb - The fOOrth Class class library.
module XfOOrth

  #Create a macro to get at the current virtual machine instance.
  VirtualMachine.create_shared_method('vm', MacroSpec,
    ["vm.push(vm); "])


end
