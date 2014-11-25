# coding: utf-8

#* library/object_library.rb - The fOOrth Object class library.
module XfOOrth

  #The .class method. This allows the class of any object to be determined.
  # [obj] .class [class_of(obj)]
  Object.create_shared_method('.class', TosSpec, [],
    &lambda {|vm| vm.push(self.class)})

  #Get the name of an object or class.
  # [obj] .name ["name of obj"]
  Object.create_shared_method('.name', TosSpec, [],
    &lambda {|vm| vm.push(self.foorth_name)})

end
