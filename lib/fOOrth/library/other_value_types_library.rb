# coding: utf-8

#* library/other_value_types_library.rb - Support for true, false, and nil in
#  the fOOrth library.
module XfOOrth

  # Connect the TrueClass class to the fOOrth class system.
  TrueClass.create_foorth_proxy

  # [] true [true]
  VirtualMachine.create_shared_method('true', MacroSpec, [:macro, "vm.push(true); "])

  #Connect the FalseClass class to the fOOrth class system.
  FalseClass.create_foorth_proxy

  # [] false [false]
  VirtualMachine.create_shared_method('false', MacroSpec, [:macro, "vm.push(false); "])

  # Connect the NilClass class to the fOOrth class system.
  NilClass.create_foorth_proxy

  # [] nil [nil]
  VirtualMachine.create_shared_method('nil', MacroSpec, [:macro, "vm.push(nil); "])


  # Some boolean operation words.

  # [b,a] && [b&a]
  Object.create_shared_method('&&', TosSpec, [],
    &lambda {|vm| vm.poke(vm.peek?); })
  FalseClass.create_shared_method('&&', TosSpec, [],
    &lambda {|vm| vm.poke(false); })
  NilClass.create_shared_method('&&', TosSpec, [],
    &lambda {|vm| vm.poke(false); })

  # [b,a] || [b|a]
  Object.create_shared_method('||', TosSpec, [],
    &lambda {|vm| vm.poke(true); })
  FalseClass.create_shared_method('||', TosSpec, [],
    &lambda {|vm| vm.poke(vm.peek?); })
  NilClass.create_shared_method('||', TosSpec, [],
    &lambda {|vm| vm.poke(vm.peek?); })

  # [b,a] ^^ [b^a]
  Object.create_shared_method('^^', TosSpec, [],
    &lambda {|vm| vm.poke(!vm.peek?); })
  FalseClass.create_shared_method('^^', TosSpec, [],
    &lambda {|vm| vm.poke(vm.peek?); })
  NilClass.create_shared_method('^^', TosSpec, [],
    &lambda {|vm| vm.poke(vm.peek?); })

  # [a] not [!a]
  Object.create_shared_method('not', TosSpec, [],
    &lambda {|vm| vm.push(false); })
  FalseClass.create_shared_method('not', TosSpec, [],
    &lambda {|vm| vm.push(true); })
  NilClass.create_shared_method('not', TosSpec, [],
    &lambda {|vm| vm.push(true); })


  # Some nil operation words

  # [a] =nil [true/false]
  Object.create_shared_method('=nil', TosSpec, [],
    &lambda {|vm| vm.push(false); })
  NilClass.create_shared_method('=nil', TosSpec, [],
    &lambda {|vm| vm.push(true); })

  # [a] <>nil [true/false]
  Object.create_shared_method('<>nil', TosSpec, [],
    &lambda {|vm| vm.push(true); })
  NilClass.create_shared_method('<>nil', TosSpec, [],
    &lambda {|vm| vm.push(false); })


  # Special Float values.

  # [] epsilon [Float::EPSILON]
  VirtualMachine.create_shared_method('epsilon', MacroSpec, [:macro, "vm.push(Float::EPSILON); "])

  # [] infinity [Float::INFINITY]
  VirtualMachine.create_shared_method('infinity', MacroSpec, [:macro, "vm.push(Float::INFINITY); "])

  # [] -infinity [-Float::INFINITY]
  VirtualMachine.create_shared_method('-infinity', MacroSpec, [:macro, "vm.push(-Float::INFINITY); "])

  # [] max_float [Float::MAX]
  VirtualMachine.create_shared_method('max_float', MacroSpec, [:macro, "vm.push(Float::MAX); "])

  # [] min_float [Float::MIN]
  VirtualMachine.create_shared_method('min_float', MacroSpec, [:macro, "vm.push(Float::MIN); "])

  # [] nan [Float::NAN]
  VirtualMachine.create_shared_method('nan', MacroSpec, [:macro, "vm.push(Float::NAN); "])

end
