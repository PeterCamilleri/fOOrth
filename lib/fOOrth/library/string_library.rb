# coding: utf-8

#* library/string_library.rb - String support for the fOOrth library.
module XfOOrth

  #Connect the String class to the fOOrth class system.
  String.create_foorth_proxy

  # [a n] .lj ['a    ']
  VirtualMachine.create_shared_method('.lj', VmSpec, [],
    &lambda {|vm| width = pop.to_i;  poke(peek.to_s.ljust(width)); })

  # [a n] .cj ['  a  ']
  VirtualMachine.create_shared_method('.cj', VmSpec, [],
    &lambda {|vm| width = pop.to_i;  poke(peek.to_s.center(width)); })

  # [a n] .rj ['    a']
  VirtualMachine.create_shared_method('.rj', VmSpec, [],
    &lambda {|vm| width = pop.to_i;  poke(peek.to_s.rjust(width)); })

end
