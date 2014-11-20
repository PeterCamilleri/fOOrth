# coding: utf-8

#* library/class_library.rb - The fOOrth Class class library.
module XfOOrth

  #Create a new instance of this class of objects.
  Object.create_shared_method('.new', TosSpec, [],
    &lambda {|vm| vm.push(self.create_foorth_instance(vm)); })

  #The .parent_class method. Retrieves the parent class of a class.
  Class.create_shared_method('.parent_class', TosSpec, [],
    &lambda {|vm| vm.push(self.superclass)})

  #The .is_class? method. Is the object a class object?
  SymbolMap.add_entry('.is_class?', :foorth_is_class?)
  Object.create_shared_method('.is_class?', TosSpec, [],
    &lambda {|vm| vm.push(false)})

  Class.create_shared_method('.is_class?', TosSpec, [],
    &lambda {|vm| vm.push(true)})

  #Create a new subclass of an existing class.
  Class.create_shared_method('.subclass:', TosSpec, [], &lambda {|vm|
    name = vm.parser.get_word()
    self.create_foorth_subclass(name)
  })

  #Create a new subclass of the Object class.
  VirtualMachine.create_shared_method('class:', VmSpec, [], &lambda {|vm|
    name = vm.parser.get_word()
    Object.create_foorth_subclass(name)
  })

end
