# coding: utf-8

#* library/class_library.rb - The fOOrth Class class library.
module XfOOrth

  #Create a new instance of this class of objects.
  # [{optional args for .init}  a_class] .new [an_instance]
  Class.create_shared_method('.new', TosSpec, [],
    &lambda {|vm| vm.push(self.create_foorth_instance(vm)); })

  #Get the class as a string.
  # [cls] .to_s ["cls as a string"]
  Class.create_shared_method('.to_s', TosSpec, [],
    &lambda {|vm| vm.push(self.foorth_name)})

  #The .parent_class method. Retrieves the parent class of a class.
  # [a_class] .parent_class [parent_class or nil]
  Class.create_shared_method('.parent_class', TosSpec, [], &lambda {|vm|
    #Ugly hack. Sorry :-(
    if self == Object
      vm.push(nil)
    elsif (self == Class) || self < Exception
      vm.push(Object)
    else
      vm.push(self.superclass)
    end
  })

  #The .is_class? method. Is the object a class object?
  # [obj] .is_class? [boolean]
  Object.create_shared_method('.is_class?', TosSpec, [],
    &lambda {|vm| vm.push(false)})

  Class.create_shared_method('.is_class?', TosSpec, [],
    &lambda {|vm| vm.push(true)})

  #Create a new subclass of an existing class.
  # [a_class] .subclass: <ClassName> []; Create subclass of a_class <ClassName>
  Class.create_shared_method('.subclass:', TosSpec, [], &lambda {|vm|
    name = vm.parser.get_word()
    self.create_foorth_subclass(name)
  })

  #Create a new subclass of the Object class.
  # [] class: <ClassName> []; Create subclass of Object <ClassName>
  VirtualMachine.create_shared_method('class:', VmSpec, [], &lambda {|vm|
    name = vm.parser.get_word()
    Object.create_foorth_subclass(name)
  })

end
