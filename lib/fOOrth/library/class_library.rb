# coding: utf-8

#* library/class_library.rb - The fOOrth Class class library.
module XfOOrth

  #Create a macro to get at the Class class.
  @object_class.create_shared_method('Class', MacroWordSpec,
    ["vm.push(XfOOrth.class_class); "])

  #Create a new instance of this class of objects.
  @object_class.create_shared_method('.new', PublicWordSpec, [],
    &lambda {|vm| vm.push(self.create_foorth_instance(vm)); })

  #The .parent_class method. Retrieves the parent class of a class.
  @class_class.create_shared_method('.parent_class', PublicWordSpec, [],
    &lambda {|vm| vm.push(self.foorth_parent)})

  #The .is_class? method. Is the object a class object?
  SymbolMap.add_entry('.is_class?', :foorth_is_class?)
  @object_class.create_shared_method('.is_class?', PublicWordSpec, [],
    &lambda {|vm| vm.push(false)})

  @class_class.create_shared_method('.is_class?', PublicWordSpec, [],
    &lambda {|vm| vm.push(true)})

end
