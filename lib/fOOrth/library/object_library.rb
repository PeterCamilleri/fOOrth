# coding: utf-8

#* library/object_library.rb - The fOOrth Object class library.
module XfOOrth

  #The .class method. This allows the class of any object to be determined.
  Object.create_shared_method('.class', PublicWordSpec, [],
    &lambda {|vm| vm.push(self.class)})

  #Get the name of an object or class.
  Object.create_shared_method('.name', PublicWordSpec, [],
    &lambda {|vm| vm.push(self.foorth_name)})

end
