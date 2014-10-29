# coding: utf-8

#* library/class_library.rb - The fOOrth Class class library.
module XfOOrth

  #Create a macro to get at the Class class.
  @object_class.create_shared_method('Class', MacroWordSpec,
    ["vm.push(XfOOrth.class_class); "])


end
