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

  fmt_action = lambda {|vm| fmt_str = pop.to_s;  poke(fmt_str % peek); }

  # [a fmt_str] .fmt ['a formatted string']
  VirtualMachine.create_shared_method('.fmt', VmSpec, [], &fmt_action)

  # [a] .fmt"fmt_str" ['a formatted string']
  VirtualMachine.create_shared_method('.fmt"', VmSpec, [], &fmt_action)

  # ['abcdefgh' w] .left ['ab']         // Assumes w = 2
  VirtualMachine.create_shared_method('.left', VmSpec, [],
    &lambda {|vm| width = pop.to_i;  poke(peek[0...width]); })

  # ['abcdefgh' w] .-left ['cdefgh']    // Assumes w = 2
  VirtualMachine.create_shared_method('.-left', VmSpec, [],
    &lambda {|vm| width = pop.to_i;  poke(peek[width..-1]); })

  # ['abcdefgh' w '123'] .+left ['123cdefgh']    // Assumes w = 2
  VirtualMachine.create_shared_method('.+left', VmSpec, [], &lambda {|vm|
    ins = pop.to_s
    width = pop.to_i
    poke(ins + peek[width..-1])
  })

  # ['abcdefgh' n w] .mid ['cdef']      // Assumes n = 2, w = 4
  VirtualMachine.create_shared_method('.mid', VmSpec, [], &lambda {|vm|
    width = pop.to_i
    posn = pop.to_i
    poke(peek[posn...(posn+width)])
  })

  # ['abcdefgh' n w] .-mid ['abgh']     // Assumes n = 2, w = 4
  VirtualMachine.create_shared_method('.-mid', VmSpec, [], &lambda {|vm|
    width = pop.to_i
    posn = pop.to_i
    poke(peek[0...posn] + peek[(posn+width)..-1])
  })

  # ['abcdefgh' n w "123"] .+mid ['ab123gh'] // Assumes n = 2, w = 4
  VirtualMachine.create_shared_method('.+mid', VmSpec, [], &lambda {|vm|
    ins = pop.to_s
    width = pop.to_i
    posn = pop.to_i
    poke(peek[0...posn] + ins + peek[(posn+width)..-1])
  })

  # ['abcdefgh' l r] .midlr ['bcdefg']  // Assumes l = 1, r = 1
  VirtualMachine.create_shared_method('.midlr', VmSpec, [], &lambda {|vm|
    right = pop.to_i
    left  = pop.to_i
    poke(peek[left...(0-right)])
  })

  # ['abcdefgh' l r] .-midlr ['ah']     // Assumes l = 1, r = 1
  VirtualMachine.create_shared_method('.-midlr', VmSpec, [], &lambda {|vm|
    right = pop.to_i
    left  = pop.to_i
    poke(peek[0...left] + peek[((0-right))..-1])
  })

  # ['abcdefgh' l r "123"] .+midlr ['a123h']     // Assumes l = 1, r = 1
  VirtualMachine.create_shared_method('.+midlr', VmSpec, [], &lambda {|vm|
    ins = pop.to_s
    right = pop.to_i
    left  = pop.to_i
    poke(peek[0...left] + ins + peek[((0-right))..-1])
  })

  # ['abcdefgh' w] .right ['gh']        // Assumes w = 2
  VirtualMachine.create_shared_method('.right', VmSpec, [],
    &lambda {|vm| width = pop.to_i;  poke(peek[(0-width)..-1]); })

  # ['abcdefgh' w] .-right ['abcdef']   // Assumes w = 2
  VirtualMachine.create_shared_method('.-right', VmSpec, [],
    &lambda {|vm| width = pop.to_i;  poke(peek[0...(0-width)]); })

  # ['abcdefgh' w "123"] .+right ['abcdef123']   // Assumes w = 2
  VirtualMachine.create_shared_method('.+right', VmSpec, [], &lambda {|vm|
    ins = pop.to_s
    width = pop.to_i
    poke(peek[0...(0-width)] + ins)
  })

  # ["a"] .length [n]
  String.create_shared_method('.length', NosSpec, [],
    &lambda {|vm| vm.push(self.length); })

  # ["b", a] + ["ba"]; "ba" is a new object, distinct from "b"
  String.create_shared_method('+', NosSpec, [],
    &lambda {|vm| vm.poke(self + vm.peek.to_s); })

  # ["b", a] << ["ba"]; "ba" is the same object as "b"
  String.create_shared_method('<<', NosSpec, [],
    &lambda {|vm| vm.poke(self << vm.peek.to_s); })

  # ["b", n] * ["bbb..."]
  String.create_shared_method('*', NosSpec, [],
    &lambda {|vm| vm.poke(self * vm.peek.to_i); })
end
