# coding: utf-8

#* library/other_value_types_library.rb - Support for true, false, and nil in
#  the fOOrth library.
module XfOOrth

  #Connect the TrueClass class to the fOOrth class system.
  TrueClass.create_foorth_proxy

  # [] true [true]
  VirtualMachine.create_shared_method('true', MacroSpec, [:macro, "vm.push(true); "])

  #Connect the FalseClass class to the fOOrth class system.
  FalseClass.create_foorth_proxy

  # [] false [false]
  VirtualMachine.create_shared_method('false', MacroSpec, [:macro, "vm.push(false); "])

  #Connect the NilClass class to the fOOrth class system.
  NilClass.create_foorth_proxy

  # [] nil [nil]
  VirtualMachine.create_shared_method('nil', MacroSpec, [:macro, "vm.push(nil); "])

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
