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
  Object.create_shared_method('self', MacroSpec, [:macro, "vm.push(self); "])

  #Get the name of an object or class.
  # [obj] .name ["name of obj"]
  Object.create_shared_method('.name', TosSpec, [],
    &lambda {|vm| vm.push(self.foorth_name)})

  #Get the object as a string.
  # [obj] .to_s ["obj as a string"]
  Object.create_shared_method('.to_s', TosSpec, [],
    &lambda {|vm| vm.push(self.to_s)})

  #Get the length of the object as a string.
  # [obj] .strlen [n]; the length of the object's to_s string
  Object.create_shared_method('.strlen', TosSpec, [],
    &lambda {|vm| self.to_foorth_s(vm); vm.poke(vm.peek.length)})

  # Some boolean operation words.
  # [b,a] && [b&a]
  Object.create_shared_method('&&', TosSpec, [],
    &lambda {|vm| vm.poke(self.to_foorth_b && vm.peek?); })

  # [b,a] || [b|a]
  Object.create_shared_method('||', TosSpec, [],
    &lambda {|vm| vm.poke(self.to_foorth_b || vm.peek?); })

  # [b,a] ^^ [b^a]
  Object.create_shared_method('^^', TosSpec, [],
    &lambda {|vm| vm.poke(self.to_foorth_b ^ vm.peek?); })

  # [a] not [!a]
  Object.create_shared_method('not', TosSpec, [],
    &lambda {|vm| vm.push(!(self.to_foorth_b)); })

  # Some comparison words.
  # [b,a] = if b == a then [true] else [false]
  Object.create_shared_method('=', NosSpec, [],
    &lambda {|vm| vm.poke(self == vm.peek); })

  # [b,a] <> if b != a then [true] else [false]
  Object.create_shared_method('<>', NosSpec, [],
    &lambda {|vm| vm.poke(self != vm.peek); })

  # [b,a] > if b > a then [true] else [false]
  Object.create_shared_method('>', NosSpec, [],
    &lambda {|vm| vm.poke(self > vm.peek); })

  # [b,a] < if b < a then [true] else [false]
  Object.create_shared_method('<', NosSpec, [],
    &lambda {|vm| vm.poke(self < vm.peek); })

  # [b,a] >= if b >= a then [true] else [false]
  Object.create_shared_method('>=', NosSpec, [],
    &lambda {|vm| vm.poke(self >= vm.peek); })

  # [b,a] <= if b <= a then [true] else [false]
  Object.create_shared_method('<=', NosSpec, [],
    &lambda {|vm| vm.poke(self <= vm.peek); })

  # [b,a] 0<=> b < a [-1], b = a [0], b > a [1]
  Object.create_shared_method('<=>', NosSpec, [],
    &lambda {|vm| vm.poke(self <=> vm.peek); })

  # Some identity comparison words.
  # [b,a] identical? if b.object_id == a.object_id then [true] else [false]
  Object.create_shared_method('identical?', NosSpec, [],
    &lambda {|vm| vm.poke(self.object_id == vm.peek.object_id); })

  # [b,a] distinct? if b.object_id != a.object_id then [true] else [false]
  Object.create_shared_method('distinct?', NosSpec, [],
    &lambda {|vm| vm.poke(self.object_id != vm.peek.object_id); })

  # Some comparison with zero words.
  # [b,a] 0= if b == 0 then [true] else [false]
  Object.create_shared_method('0=', TosSpec, [],
    &lambda {|vm| vm.push(self == 0); })

  # [b,a] 0<> if b != 0 then [true] else [false]
  Object.create_shared_method('0<>', TosSpec, [],
    &lambda {|vm| vm.push(self != 0); })

  # [b,a] 0> if b > 0 then [true] else [false]
  Object.create_shared_method('0>', TosSpec, [],
    &lambda {|vm| vm.push(self > 0); })

  # [b,a] 0< if b < 0 then [true] else [false]
  Object.create_shared_method('0<', TosSpec, [],
    &lambda {|vm| vm.push(self < 0); })

  # [b,a] 0>= if b >= 0 then [true] else [false]
  Object.create_shared_method('0>=', TosSpec, [],
    &lambda {|vm| vm.push(self >= 0); })

  # [b,a] 0<= if b <= 0 then [true] else [false]
  Object.create_shared_method('0<=', TosSpec, [],
    &lambda {|vm| vm.push(self <= 0); })

  # [b] 0<=> b < 0 [-1], b = 0 [0], b > 0 [1]
  Object.create_shared_method('0<=>', TosSpec, [],
    &lambda {|vm| vm.push(self <=> 0); })

  # [b,a] max [max(b,a)]
  Object.create_shared_method('max', TosSpec, [],
    &lambda {|vm| other = vm.peek; vm.poke(self > other ? self : other); })

  # [b,a] min [min(b,a)]
  Object.create_shared_method('min', TosSpec, [],
    &lambda {|vm| other = vm.peek; vm.poke(self < other ? self : other); })

end

