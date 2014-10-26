# coding: utf-8

#* library/stdio_library.rb - The standard I/O fOOrth library.
module XfOOrth

  #===================================================
  # Some basic console I/O words.
  #===================================================

  #Print out an object.
  @object_class.create_shared_method('.', PublicWordSpec, [],
    &lambda {|vm| print self.to_s})

  #Print out a string.
  VirtualMachine.create_shared_method('."', VmWordSpec, [],
    &lambda {|vm| print pop})

  #Force a new line.
  VirtualMachine.create_shared_method('.cr', MacroWordSpec,
    ['"puts; "'])

  #Force a space.
  VirtualMachine.create_shared_method('space', MacroWordSpec,
    ['"print \' \'; "'])

  #Force multiple spaces.
  VirtualMachine.create_shared_method('spaces', MacroWordSpec,
    ['"print \' \' * vm.pop(); "'])

end