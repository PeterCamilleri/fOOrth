# coding: utf-8

#* library/class_library.rb - The fOOrth Class class library.
module XfOOrth

  #Create a macro to get at the Virtual Machine class.
  object_class.create_shared_method('VirtualMachine', MacroWordSpec,
    ["vm.push(VirtualMachine); "])

  #Create a macro to get at the current virtual machine instance.
  VirtualMachine.create_shared_method('vm', MacroWordSpec,
    ["vm.push(vm); "])


end
