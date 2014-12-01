# coding: utf-8

#* library/string_library.rb - String support for the fOOrth library.
module XfOOrth

  #Connect the String class to the fOOrth class system.
  String.create_foorth_proxy

  # [n a] .ljust ['a    ']; left justify
  String.create_shared_method('.ljust', TosSpec, [],
    &lambda {|vm| vm.poke(self.ljust(vm.peek.to_i)); })

  # [n a] .cjust ['  a  ']; center justify
  String.create_shared_method('.cjust', TosSpec, [],
    &lambda {|vm| vm.poke(self.center(vm.peek.to_i)); })

  # [n a] .rjust ['    a']; right justify
  String.create_shared_method('.rjust', TosSpec, [],
    &lambda {|vm| vm.poke(self.rjust(vm.peek.to_i)); })

  # ["  a  "] .lstrip ["a  "]; left strip
  String.create_shared_method('.lstrip', TosSpec, [],
    &lambda {|vm| vm.push(self.lstrip); })

  # ["  a  "] .strip ["a"]; left and right strip
  String.create_shared_method('.strip', TosSpec, [],
    &lambda {|vm| vm.push(self.strip); })

  # ["  a  "] .rstrip ["  a"]; right strip
  String.create_shared_method('.rstrip', TosSpec, [],
    &lambda {|vm| vm.push(self.rstrip); })

  fmt_action = lambda {|vm| vm.poke(self % vm.peek); }

  # [a fmt_str] .fmt ['a formatted string']
  String.create_shared_method('.fmt', TosSpec, [], &fmt_action)

  # [a] .fmt"fmt_str" ['a formatted string']
  String.create_shared_method('.fmt"', TosSpec, [], &fmt_action)

  # [w 'abcdefgh'] .left ['ab']         // Assumes w = 2
  String.create_shared_method('.left', TosSpec, [],
    &lambda {|vm| vm.poke(self[0...(vm.peek.to_i)]); })

  # [w 'abcdefgh'] .-left ['cdefgh']    // Assumes w = 2
  String.create_shared_method('.-left', TosSpec, [],
    &lambda {|vm| vm.poke(self[(vm.peek.to_i)..-1]); })

  # [w '123''abcdefgh'] .+left ['123cdefgh']    // Assumes w = 2
  String.create_shared_method('.+left', TosSpec, [], &lambda {|vm|
    ins = vm.pop.to_s
    vm.poke(ins + self[(vm.peek.to_i)..-1])
  })

  # [n w 'abcdefgh'] .mid ['cdef']      // Assumes n = 2, w = 4
  String.create_shared_method('.mid', TosSpec, [], &lambda {|vm|
    width = vm.pop.to_i
    posn = vm.pop.to_i
    vm.push(self[posn...(posn+width)])
  })

  # [n w 'abcdefgh'] .-mid ['abgh']     // Assumes n = 2, w = 4
  String.create_shared_method('.-mid', TosSpec, [], &lambda {|vm|
    width = vm.pop.to_i
    posn = vm.pop.to_i
    vm.push(self[0...posn] + self[(posn+width)..-1])
  })

  # [n w "123" "abcdefgh"] .+mid ["ab123gh"] // Assumes n = 2, w = 4
  String.create_shared_method('.+mid', TosSpec, [], &lambda {|vm|
    ins = vm.pop.to_s
    width = vm.pop.to_i
    posn = vm.pop.to_i
    vm.push(self[0...posn] + ins + self[(posn+width)..-1])
  })

  # [l r 'abcdefgh'] .midlr ['bcdefg']  // Assumes l = 1, r = 1
  String.create_shared_method('.midlr', TosSpec, [], &lambda {|vm|
    right = vm.pop.to_i
    left  = vm.pop.to_i
    vm.push(self[left...(0-right)])
  })

  # ['abcdefgh' l r] .-midlr ['ah']     // Assumes l = 1, r = 1
  String.create_shared_method('.-midlr', TosSpec, [], &lambda {|vm|
    right = vm.pop.to_i
    left  = vm.pop.to_i
    vm.push(self[0...left] + self[((0-right))..-1])
  })

  # [l r "123" 'abcdefgh'] .+midlr ['a123h']     // Assumes l = 1, r = 1
  String.create_shared_method('.+midlr', TosSpec, [], &lambda {|vm|
    ins = vm.pop.to_s
    right = vm.pop.to_i
    left  = vm.pop.to_i
    vm.push(self[0...left] + ins + self[((0-right))..-1])
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

  # ["abCD"] .to_upper ["ABCD"]
  String.create_shared_method('.to_upper', TosSpec, [],
    &lambda {|vm| vm.push(self.upcase); })

  # ["abCD"] .to_lower ["abcd"]
  String.create_shared_method('.to_lower', TosSpec, [],
    &lambda {|vm| vm.push(self.downcase); })

  # ["stressed"] .reverse ["desserts"]
  String.create_shared_method('.reverse', TosSpec, [],
    &lambda {|vm| vm.push(self.reverse); })


end
