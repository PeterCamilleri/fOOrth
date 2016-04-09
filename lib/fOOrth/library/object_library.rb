# coding: utf-8

#* library/object_library.rb - The fOOrth Object class library.
module XfOOrth

  #The .class method. This allows the class of any object to be determined.
  # [obj] .class [class_of(obj)]
  Object.create_shared_method('.class', TosSpec, [],
    &lambda {|vm| vm.push(self.class)})

  # Some basic "constant" value words.
  #The self method.
  # [] self [self]
  VirtualMachine.create_shared_method('self', MacroSpec, [:macro, "vm.push(self); "])

  #Get the name of an object or class.
  # [obj] .with{{ ... }} [] Execute the block with self set to obj
  Object.create_shared_method('.with{{', NosSpec, [], &lambda {|vm|
    block = vm.pop
    self.instance_exec(vm, nil, nil, &block)
  })

  #Get the name of an object or class.
  # [obj] .name ["name of obj"]
  Object.create_shared_method('.name', TosSpec, [],
    &lambda {|vm| vm.push(self.foorth_name)})

  #Get the object as a string.
  # [obj] .to_s ["obj as a string"]
  Object.create_shared_method('.to_s', TosSpec, [],
    &lambda {|vm| vm.push(self.to_s.freeze)})

  #Get the length of the object as a string.
  # [obj] .strlen [n]; the length of the object's to_s string
  Object.create_shared_method('.strlen', TosSpec, [],
    &lambda {|vm| self.to_foorth_s(vm); vm.poke(vm.peek.length)})

  # Some comparison words.
  # [b,a] = if b == a then [true] else [false]
  Object.create_shared_method('=', NosSpec, [],
    &lambda {|vm| vm.poke(self == vm.peek); })

  # [b,a] <> if b != a then [true] else [false]
  Object.create_shared_method('<>', NosSpec, [],
    &lambda {|vm| vm.poke(self != vm.peek); })


  # Some identity comparison words.
  # [b,a] identical? if b.object_id == a.object_id then [true] else [false]
  Object.create_shared_method('identical?', NosSpec, [],
    &lambda {|vm| vm.poke(self.object_id == vm.peek.object_id); })

  # [b,a] distinct? if b.object_id != a.object_id then [true] else [false]
  Object.create_shared_method('distinct?', NosSpec, [],
    &lambda {|vm| vm.poke(self.object_id != vm.peek.object_id); })


  # [b,a] max [max(b,a)]
  Object.create_shared_method('max', NosSpec, [], &lambda {|vm|
    begin
      other = vm.peek
      vm.poke((self > self.foorth_coerce(other)) ? self : other)
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # [b,a] min [min(b,a)]
  Object.create_shared_method('min', NosSpec, [], &lambda {|vm|
    begin
      other = vm.peek
      vm.poke((self < self.foorth_coerce(other)) ? self : other)
    rescue
      vm.data_stack.pop
      raise
    end
  })

end
