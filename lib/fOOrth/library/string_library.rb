# coding: utf-8

#* library/string_library.rb - String support for the fOOrth library.
module XfOOrth

  #Connect the String class to the fOOrth class system.
  String.create_foorth_proxy

  # A no operation place holder for string literals
  VirtualMachine.create_shared_method('"', MacroSpec, [:macro, " "])

  #Some comparison operators
  # [b,a] > if b > a then [true] else [false]
  String.create_shared_method('>', NosSpec, [],
    &lambda {|vm| vm.poke(self > vm.peek.to_s); })

  # [b,a] < if b < a then [true] else [false]
  String.create_shared_method('<', NosSpec, [],
    &lambda {|vm| vm.poke(self < vm.peek.to_s); })

  # [b,a] >= if b >= a then [true] else [false]
  String.create_shared_method('>=', NosSpec, [],
    &lambda {|vm| vm.poke(self >= vm.peek.to_s); })

  # [b,a] <= if b <= a then [true] else [false]
  String.create_shared_method('<=', NosSpec, [],
    &lambda {|vm| vm.poke(self <= vm.peek.to_s); })

  # [b,a] <=> if b <=> a then [true] else [false]
  String.create_shared_method('<=>', NosSpec, [],
    &lambda {|vm| vm.poke(self <=> vm.peek.to_s); })


  #Some string manipulation methods.
  # [n a] .ljust ['a    ']; left justify
  String.create_shared_method('.ljust', TosSpec, [],
    &lambda {|vm| vm.poke(self.ljust(Integer.foorth_coerce(vm.peek))); })

  # [n a] .cjust ['  a  ']; center justify
  String.create_shared_method('.cjust', TosSpec, [],
    &lambda {|vm| vm.poke(self.center(Integer.foorth_coerce(vm.peek))); })

  # [n a] .rjust ['    a']; right justify
  String.create_shared_method('.rjust', TosSpec, [],
    &lambda {|vm| vm.poke(self.rjust(Integer.foorth_coerce(vm.peek))); })

  # ["  a  "] .lstrip ["a  "]; left strip
  String.create_shared_method('.lstrip', TosSpec, [],
    &lambda {|vm| vm.push(self.lstrip); })

  # ["  a  "] .strip ["a"]; left and right strip
  String.create_shared_method('.strip', TosSpec, [],
    &lambda {|vm| vm.push(self.strip); })

  # ["  a  "] .rstrip ["  a"]; right strip
  String.create_shared_method('.rstrip', TosSpec, [],
    &lambda {|vm| vm.push(self.rstrip); })

  fmt_action = lambda {|vm| vm.poke(self % vm.peek.in_array); }

  # [a fmt_str] .fmt ['a formatted string']
  String.create_shared_method('.fmt', TosSpec, [], &fmt_action)

  # [a] .fmt"fmt_str" ['a formatted string']
  String.create_shared_method('.fmt"', TosSpec, [], &fmt_action)

  #LEFT Group

  # [w 'abcdefgh'] .left ['ab']         // Assumes w = 2
  String.create_shared_method('.left', TosSpec, [],
    &lambda {|vm| vm.poke(self[0...(Integer.foorth_coerce(vm.peek))]); })

  # [w 'abcdefgh'] .-left ['cdefgh']    // Assumes w = 2
  String.create_shared_method('.-left', TosSpec, [],
    &lambda {|vm| vm.poke(self[(Integer.foorth_coerce(vm.peek))..-1]); })

  # [w '123''abcdefgh'] .+left ['123cdefgh']    // Assumes w = 2
  String.create_shared_method('.+left', TosSpec, [], &lambda {|vm|
    ins = vm.pop.to_s
    vm.poke(ins + self[(Integer.foorth_coerce(vm.peek))..-1])
  })

  # ['abc' 'abcdefgh'] .left? [boolean]
  String.create_shared_method('.left?', TosSpec, [],
    &lambda {|vm| vm.poke(self.start_with?(vm.peek)); })


  #MID Group

  # [n w 'abcdefgh'] .mid ['cdef']      // Assumes n = 2, w = 4
  String.create_shared_method('.mid', TosSpec, [], &lambda {|vm|
    width = Integer.foorth_coerce(vm.pop)
    posn = Integer.foorth_coerce(vm.pop)
    vm.push(self[posn...(posn+width)])
  })

  # [n w 'abcdefgh'] .-mid ['abgh']     // Assumes n = 2, w = 4
  String.create_shared_method('.-mid', TosSpec, [], &lambda {|vm|
    width = Integer.foorth_coerce(vm.pop)
    posn = Integer.foorth_coerce(vm.pop)
    vm.push(self[0...posn] + self[(posn+width)..-1])
  })

  # [n w "123" "abcdefgh"] .+mid ["ab123gh"] // Assumes n = 2, w = 4
  String.create_shared_method('.+mid', TosSpec, [], &lambda {|vm|
    ins = vm.pop.to_s
    width = Integer.foorth_coerce(vm.pop)
    posn = Integer.foorth_coerce(vm.pop)
    vm.push(self[0...posn] + ins + self[(posn+width)..-1])
  })

  # [n 'cde' 'abcdefgh'] .mid? [true]      // Assumes n = 2
  String.create_shared_method('.mid?', TosSpec, [], &lambda {|vm|
    search = vm.pop.to_s
    width  = search.length
    posn   = Integer.foorth_coerce(vm.pop)
    vm.push(self[posn...(posn+width)] == search)
  })


  #MIDLR Group

  # [l r 'abcdefgh'] .midlr ['bcdefg']  // Assumes l = 1, r = 1
  String.create_shared_method('.midlr', TosSpec, [], &lambda {|vm|
    right = Integer.foorth_coerce(vm.pop)
    left  = Integer.foorth_coerce(vm.pop)
    vm.push(self[left...(0-right)])
  })

  # [l r 'abcdefgh'] .-midlr ['ah']     // Assumes l = 1, r = 1
  String.create_shared_method('.-midlr', TosSpec, [], &lambda {|vm|
    right = Integer.foorth_coerce(vm.pop)
    left  = Integer.foorth_coerce(vm.pop)
    vm.push(self[0...left] + self[((0-right))..-1])
  })

  # [l r "123" 'abcdefgh'] .+midlr ['a123h']     // Assumes l = 1, r = 1
  String.create_shared_method('.+midlr', TosSpec, [], &lambda {|vm|
    ins = vm.pop.to_s
    right = Integer.foorth_coerce(vm.pop)
    left  = Integer.foorth_coerce(vm.pop)
    vm.push(self[0...left] + ins + self[((0-right))..-1])
  })

  #RIGHT Group

  # [w 'abcdefgh'] .right ['gh']        // Assumes w = 2
  String.create_shared_method('.right', TosSpec, [],
    &lambda {|vm| vm.poke(self[(0-(Integer.foorth_coerce(vm.peek)))..-1]); })

  # [w 'abcdefgh'] .-right ['abcdef']   // Assumes w = 2
  String.create_shared_method('.-right', TosSpec, [],
    &lambda {|vm| vm.poke(self[0...(0-(Integer.foorth_coerce(vm.peek)))]); })

  # [w "123" 'abcdefgh'] .+right ['abcdef123']   // Assumes w = 2
  String.create_shared_method('.+right', TosSpec, [], &lambda {|vm|
    ins = vm.pop.to_s
    width = Integer.foorth_coerce(vm.pop)
    vm.push(self[0...(0-width)] + ins)
  })

  # ['fgh' 'abcdefgh'] .right? [boolean]
  String.create_shared_method('.right?', TosSpec, [],
    &lambda {|vm| vm.poke(self.end_with?(vm.peek)); })

  #Other String Methods

  # ['cde' 'abcdefgh'] .contains? [boolean]
  String.create_shared_method('.contains?', TosSpec, [],
    &lambda {|vm| vm.poke(self.index(vm.peek).to_foorth_b); })

  # ['cde' 'abcdefgh'] .posn [position or nil]
  String.create_shared_method('.posn', TosSpec, [],
    &lambda {|vm| vm.poke(self.index(vm.peek)); })

  # ["a"] .length [n]
  String.create_shared_method('.length', TosSpec, [],
    &lambda {|vm| vm.push(self.length); })

  # ["b", a] + ["ba"]; "ba" is a new object, distinct from "b"
  String.create_shared_method('+', NosSpec, [],
    &lambda {|vm| vm.poke(self + vm.peek.to_s); })

  # ["b", a] << ["ba"]; "ba" is the same object as "b"
  String.create_shared_method('<<', NosSpec, [],
    &lambda {|vm| vm.poke(self << vm.peek.to_s); })

  # ["b", n] * ["bbb..."]
  String.create_shared_method('*', NosSpec, [],
    &lambda {|vm| vm.poke(self * Integer.foorth_coerce(vm.peek)); })

  # ["abCD"] .to_upper ["ABCD"]
  String.create_shared_method('.to_upper', TosSpec, [],
    &lambda {|vm| vm.push(self.upcase); })

  # ["abCD"] .to_lower ["abcd"]
  String.create_shared_method('.to_lower', TosSpec, [],
    &lambda {|vm| vm.push(self.downcase); })

  # ["stressed"] .reverse ["desserts"]
  String.create_shared_method('.reverse', TosSpec, [],
    &lambda {|vm| vm.push(self.reverse); })

  # ["abc\\ndef\\n123"] .lines [["abc", "def", "123"]]
  String.create_shared_method('.lines', TosSpec, [],
    &lambda {|vm| vm.push(self.lines.to_a.collect {|line| line.chomp}) })

  # ["abc def 123"] .split [["abc", "def", "123"]]
  String.create_shared_method('.split', TosSpec, [],
    &lambda {|vm| vm.push(self.split(' ')) })

  # [file_name_string] .load [undefined]; load the file as source code.
  String.create_shared_method('.load', TosSpec, [], &lambda {|vm|
    if File.extname(self) == '' && !self.end_with?('.')
      file_name = self + '.foorth'
    else
      file_name = self
    end

    unless File.exists?(file_name)
      error "F50: Unable to locate file #{file_name}"
    end

    vm.process_file(file_name)
  })

  # [] .load"file_name_string" [undefined]; load the file as source code.
  VirtualMachine.create_shared_method('load"', VmSpec, [], &lambda{|vm|
    vm.pop.foorth_load_file(vm)
  })

  # ["a_string"] .call [unspecified]; Execute the string as source code.
  String.create_shared_method('.call', TosSpec, [], &lambda {|vm|
    vm.process_string(self)
  })

  # ["Error message"] .throw []; Raises an exception.
  String.create_shared_method('.throw', TosSpec, [], &lambda {|vm|
    raise XfOOrth::XfOOrthError, self, caller
  })

  # [] throw"Error message" []; Raises an exception.
  VirtualMachine.create_shared_method('throw"', VmSpec, [], &lambda {|vm|
    raise XfOOrth::XfOOrthError, vm.pop.to_s, caller
  })

  String.create_shared_method('.shell', TosSpec, [], &lambda {|vm|
    system(self)
  })

end

#* Runtime library support for fOOrth constructs.
class String

  # Runtime support for the .each{ } construct.
  def do_foorth_each(&block)
    key = 0
    self.chars do |value|
      block.call(value, key)
      key += 1
    end
  end

end
