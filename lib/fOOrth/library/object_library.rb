# coding: utf-8

#* library/object_library.rb - The fOOrth Object class library.
module XfOOrth

  #Create a macro to get at the Object class.
  @object_class.create_shared_method('Object', MacroWordSpec,
    ["vm.push(XfOOrth.object_class); "])

  #The .class method. This allows the class of any object to be determined.
  @object_class.create_shared_method('.class', PublicWordSpec, [],
    &lambda {|vm| vm.push(self.foorth_class)})

  #Get the name of an object or class.
  @object_class.create_shared_method('.name', PublicWordSpec, [],
    &lambda {|vm| vm.push(self.name)})

end
