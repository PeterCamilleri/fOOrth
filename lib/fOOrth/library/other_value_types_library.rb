# coding: utf-8

#* library/other_value_types_library.rb - Support for true, false, and nil in
#  the fOOrth library.
module XfOOrth

  #Connect the TrueClass class to the fOOrth class system.
  TrueClass.create_foorth_proxy

  #The true method.
  # [] true [true]
  Object.create_shared_method('true', MacroSpec, [:macro, "vm.push(true); "])

  #Connect the FalseClass class to the fOOrth class system.
  FalseClass.create_foorth_proxy

  #The false method.
  # [] false [false]
  Object.create_shared_method('false', MacroSpec, [:macro, "vm.push(false); "])

  #Connect the NilClass class to the fOOrth class system.
  NilClass.create_foorth_proxy

  #The nil method.
  # [] nil [nil]
  Object.create_shared_method('nil', MacroSpec, [:macro, "vm.push(nil); "])

end
