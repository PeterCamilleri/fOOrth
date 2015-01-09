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

  #LEFT Group

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

  # ['abc' 'abcdefgh'] .left? [boolean]
  String.create_shared_method('.left?', TosSpec, [],
    &lambda {|vm| vm.poke(self.start_with?(vm.peek)); })


  #MID Group

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

  # ['cde' 'abcdefgh'] .mid? [boolean]
  String.create_shared_method('.mid?', TosSpec, [],
    &lambda {|vm| vm.poke(self.index(vm.peek).to_foorth_b); })

  # ['cde' 'abcdefgh'] .posn [position or nil]
  String.create_shared_method('.posn', TosSpec, [],
    &lambda {|vm| vm.poke(self.index(vm.peek)); })


  #MIDLR Group

  # [l r 'abcdefgh'] .midlr ['bcdefg']  // Assumes l = 1, r = 1
  String.create_shared_method('.midlr', TosSpec, [], &lambda {|vm|
    right = vm.pop.to_i
    left  = vm.pop.to_i
    vm.push(self[left...(0-right)])
  })

  # [l r 'abcdefgh'] .-midlr ['ah']     // Assumes l = 1, r = 1
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

  #RIGHT Group

  # [w 'abcdefgh'] .right ['gh']        // Assumes w = 2
  String.create_shared_method('.right', TosSpec, [],
    &lambda {|vm| vm.poke(self[(0-(vm.peek.to_i))..-1]); })

  # [w 'abcdefgh'] .-right ['abcdef']   // Assumes w = 2
  String.create_shared_method('.-right', TosSpec, [],
    &lambda {|vm| vm.poke(self[0...(0-(vm.peek.to_i))]); })

  # [w "123" 'abcdefgh'] .+right ['abcdef123']   // Assumes w = 2
  String.create_shared_method('.+right', TosSpec, [], &lambda {|vm|
    ins = vm.pop.to_s
    width = vm.pop.to_i
    vm.push(self[0...(0-width)] + ins)
  })

  # ['fgh' 'abcdefgh'] .right? [boolean]
  String.create_shared_method('.right?', TosSpec, [],
    &lambda {|vm| vm.poke(self.end_with?(vm.peek)); })


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

  # ["abc\\ndef\\n123"] .lines [["abc", "def", "123"]]
  String.create_shared_method('.lines', TosSpec, [],
    &lambda {|vm| vm.push(self.lines.to_a.collect {|line| line.chomp}) })

  # ["abc def 123"] .split [["abc", "def", "123"]]
  String.create_shared_method('.split', TosSpec, [],
    &lambda {|vm| vm.push(self.split(' ')) })

  # [string] .eval [undefined]; evaluate the string as source code.
  String.create_shared_method('.eval', TosSpec, [],
    &lambda {|vm| vm.process_string(self) })

  # [file_name_string] .load [undefined]; load the file as source code.
  String.create_shared_method('.load', TosSpec, [], &lambda {|vm|
    if File.extname(self) == ''
      file_name = self + '.foorth'
    else
      file_name = self
    end

    unless File.exists?(file_name)
      error "Unable to locate file #{file_name}"
    end

    vm.process_file(file_name)
  })

  # [] .load"file_name_string" [undefined]; load the file as source code.
  VirtualMachine.create_shared_method('load"', VmSpec, [], &lambda{|vm|
    vm.pop.foorth_load_file(vm)
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
