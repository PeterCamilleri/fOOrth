# coding: utf-8

#* library/class_library.rb - The fOOrth Class class library.
module XfOOrth

  #Create a macro to get at the Class class.
  @object_class.create_shared_method('Class', MacroWordSpec,
    ["vm.push(XfOOrth.class_class); "])

  #Create a new instance of this class of objects.
  @object_class.create_shared_method('.new', PublicWordSpec, [],
    &lambda {|vm| vm.push(self.create_foorth_instance(vm)); })

end
