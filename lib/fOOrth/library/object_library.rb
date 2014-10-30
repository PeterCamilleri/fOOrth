# coding: utf-8

#* library/object_library.rb - The fOOrth Object class library.
module XfOOrth

  #Create a macro to get at the Object class.
  @object_class.create_shared_method('Object', MacroWordSpec,
    ["vm.push(XfOOrth.object_class); "])

end
