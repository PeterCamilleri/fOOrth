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

  # [a fmt_str] .fmt ['a formatted string']
  VirtualMachine.create_shared_method('.fmt', VmSpec, [],
    &lambda {|vm| fmt_str = pop.to_s;  poke(fmt_str % peek); })

  # [a] .fmt"fmt_str" ['a formatted string']
  VirtualMachine.create_shared_method('.fmt"', VmSpec, [],
    &lambda {|vm| fmt_str = pop.to_s;  poke(fmt_str % peek); })


  # ['abcdefgh' w] .left ['abcd'] // Assumes w = 4


  # ['abcdefgh' w] .-left ['cdefgh'] // Assumes w = 2


  # ['abcdefgh' n w] .mid ['cdef'] // Assumes n = 2, w = 4


  # ['abcdefgh' n w] .-mid ['cdef'] // Assumes n = 2, w = 4


  # ['abcdefgh' w] .right ['efgh'] // Assumes w = 4


  # ['abcdefgh' w] .-right ['abcdef'] // Assumes w = 2


end
