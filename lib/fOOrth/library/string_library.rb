# coding: utf-8

#* library/string_library.rb - String support for the fOOrth library.
module XfOOrth

  #Connect the String class to the fOOrth class system.
  String.create_foorth_proxy

  #Connect the StringBuffer class to the fOOrth class system.
  StringBuffer.create_foorth_proxy

  # A no operation place holder for string literals
  VirtualMachine.create_shared_method('"', MacroSpec, [:macro, " "])

  # [string] .each{{ ... }} [unspecified]
  String.create_shared_method('.each{{', NosSpec, [], &lambda { |vm|
    block, idx = vm.pop, 0
    self.chars { |val| block.call(vm, val.freeze, idx); idx += 1 }
  })

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
  String.create_shared_method('.ljust', TosSpec, [], &lambda {|vm|
    vm.poke(self.to_s.ljust(Integer.foorth_coerce(vm.peek)).freeze);
  })

  # [n a] .cjust ['  a  ']; center justify
  String.create_shared_method('.cjust', TosSpec, [], &lambda {|vm|
    vm.poke(self.to_s.center(Integer.foorth_coerce(vm.peek)).freeze);
  })

  # [n a] .rjust ['    a']; right justify
  String.create_shared_method('.rjust', TosSpec, [], &lambda {|vm|
    vm.poke(self.to_s.rjust(Integer.foorth_coerce(vm.peek)).freeze);
  })

  # ["  a  "] .lstrip ["a  "]; left strip
  String.create_shared_method('.lstrip', TosSpec, [],
    &lambda {|vm| vm.push(self.to_s.lstrip.freeze); })

  # ["  a  "*] .lstrip* []; left strip in place.
  StringBuffer.create_shared_method('.lstrip*', TosSpec, [],
    &lambda {|vm| self.lstrip! })

  # ["  a  "] .strip ["a"]; left and right strip
  String.create_shared_method('.strip', TosSpec, [],
    &lambda {|vm| vm.push(self.to_s.strip.freeze); })

  # ["  a  "*] .strip* []; left and right strip in place
  StringBuffer.create_shared_method('.strip*', TosSpec, [],
    &lambda {|vm| self.strip! })

  # ["  a  "] .rstrip ["  a"]; right strip
  String.create_shared_method('.rstrip', TosSpec, [],
    &lambda {|vm| vm.push(self.to_s.rstrip.freeze); })

  # ["  a  "*] .rstrip* []; right strip in place
  StringBuffer.create_shared_method('.rstrip*', TosSpec, [],
    &lambda {|vm| self.rstrip! })

  #The shared block for string formatting.
  format_action = lambda do |vm|
    begin
      vm.poke((vm.peek % self.in_array).freeze)
    rescue => err
      vm.data_stack.pop
      error "F40: Formating error: #{err.message}."
    end
  end

  # [object_or_array fmt_str] format ['a formatted string']
  Object.create_shared_method('format', NosSpec, [], &format_action)

  # [object_or_array] f"fmt_str" ['a formatted string']
  Object.create_shared_method('f"', NosSpec, [], &format_action)

  parse_action = lambda do |vm|
    begin
      vm.poke(self.sscanf(vm.peek).map{|obj| obj.foorth_string_freeze} )
    rescue => err
      vm.data_stack.pop
      error "F40: Parsing error: #{err.message}."
    end
  end

  # [a_str fmt_str] parse [result_array]
  String.create_shared_method('parse', NosSpec, [], &parse_action)

  # [a_str] p"fmt_str" [result_array]
  String.create_shared_method('p"', NosSpec, [], &parse_action)


  #LEFT Group

  # [w 'abcdefgh'] .left ['ab']         // Assumes w = 2
  String.create_shared_method('.left', TosSpec, [],
    &lambda {|vm| vm.poke(self.to_s[0...(Integer.foorth_coerce(vm.peek))].freeze); })

  # [w 'abcdefgh'] .-left ['cdefgh']    // Assumes w = 2
  String.create_shared_method('.-left', TosSpec, [],
    &lambda {|vm| vm.poke(self.to_s[(Integer.foorth_coerce(vm.peek))..-1].freeze); })

  # [w '123''abcdefgh'] .+left ['123cdefgh']    // Assumes w = 2
  String.create_shared_method('.+left', TosSpec, [], &lambda {|vm|
    ins = vm.pop.to_s
    vm.poke((ins + self[(Integer.foorth_coerce(vm.peek))..-1]).freeze)
  })

  # ['abc' 'abcdefgh'] .left? [boolean]
  String.create_shared_method('.left?', TosSpec, [],
    &lambda {|vm| vm.poke(self.start_with?(vm.peek)); })


  #MID Group

  # [n w 'abcdefgh'] .mid ['cdef']      // Assumes n = 2, w = 4
  String.create_shared_method('.mid', TosSpec, [], &lambda {|vm|
    width = Integer.foorth_coerce(vm.pop)
    posn = Integer.foorth_coerce(vm.pop)
    vm.push(self.to_s[posn...(posn+width)].freeze)
  })

  # [n w 'abcdefgh'] .-mid ['abgh']     // Assumes n = 2, w = 4
  String.create_shared_method('.-mid', TosSpec, [], &lambda {|vm|
    width = Integer.foorth_coerce(vm.pop)
    posn = Integer.foorth_coerce(vm.pop)
    vm.push((self[0...posn] + self[(posn+width)..-1]).freeze)
  })

  # [n w "123" "abcdefgh"] .+mid ["ab123gh"] // Assumes n = 2, w = 4
  String.create_shared_method('.+mid', TosSpec, [], &lambda {|vm|
    ins = vm.pop.to_s
    width = Integer.foorth_coerce(vm.pop)
    posn = Integer.foorth_coerce(vm.pop)
    vm.push((self[0...posn] + ins + self[(posn+width)..-1]).freeze)
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
    vm.push(self.to_s[left...(0-right)].freeze)
  })

  # [l r 'abcdefgh'] .-midlr ['ah']     // Assumes l = 1, r = 1
  String.create_shared_method('.-midlr', TosSpec, [], &lambda {|vm|
    right = Integer.foorth_coerce(vm.pop)
    left  = Integer.foorth_coerce(vm.pop)
    vm.push((self[0...left] + self[((0-right))..-1]).freeze)
  })

  # [l r "123" 'abcdefgh'] .+midlr ['a123h']     // Assumes l = 1, r = 1
  String.create_shared_method('.+midlr', TosSpec, [], &lambda {|vm|
    ins = vm.pop.to_s
    right = Integer.foorth_coerce(vm.pop)
    left  = Integer.foorth_coerce(vm.pop)
    vm.push((self[0...left] + ins + self[((0-right))..-1]).freeze)
  })

  #RIGHT Group

  # [w 'abcdefgh'] .right ['gh']        // Assumes w = 2
  String.create_shared_method('.right', TosSpec, [], &lambda {|vm|
    vm.poke(self.to_s[(0-(Integer.foorth_coerce(vm.peek)))..-1].freeze);
  })

  # [w 'abcdefgh'] .-right ['abcdef']   // Assumes w = 2
  String.create_shared_method('.-right', TosSpec, [], &lambda {|vm|
    vm.poke(self.to_s[0...(0-(Integer.foorth_coerce(vm.peek)))].freeze);
  })

  # [w "123" 'abcdefgh'] .+right ['abcdef123']   // Assumes w = 2
  String.create_shared_method('.+right', TosSpec, [], &lambda {|vm|
    ins = vm.pop.to_s
    width = Integer.foorth_coerce(vm.pop)
    vm.push((self[0...(0-width)] + ins).freeze)
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
    &lambda {|vm| vm.poke((self + vm.peek.to_s).freeze) })

  # ["b", a] << [error]; Bug patch. Not fully understood.
  String.create_shared_method('<<', NosSpec, [:stub])

  # ["b"*, a] << ["ba"*]; "ba"* is the same object as "b"*
  StringBuffer.create_shared_method('<<', NosSpec, [],
    &lambda {|vm| vm.poke(self << vm.peek.to_s); })

  # ["b"*, a] >> ["ab"*]; "ab"* is the same object as "b"*
  StringBuffer.create_shared_method('>>', NosSpec, [],
    &lambda {|vm| vm.poke(self.prepend(vm.peek.to_s)); })

  # ["b", n] * ["bbb..."]
  String.create_shared_method('*', NosSpec, [], &lambda {|vm|
    begin
      vm.poke((self.to_s * Integer.foorth_coerce(vm.peek)).freeze)
    rescue
      vm.data_stack.pop
      raise
    end
  })

  # ["abCD"] .to_upper ["ABCD"]
  String.create_shared_method('.to_upper', TosSpec, [],
    &lambda {|vm| vm.push(self.to_s.upcase.freeze) })

  # ["abCD"*] .to_upper* [] #Convert to upper case in place.
  StringBuffer.create_shared_method('.to_upper*', TosSpec, [],
    &lambda {|vm| self.upcase! })

  # ["abCD"] .to_lower ["abcd"]
  String.create_shared_method('.to_lower', TosSpec, [],
    &lambda {|vm| vm.push(self.to_s.downcase.freeze) })

  # ["abCD"*] .to_lower* [] #Convert to lower case in place.
  StringBuffer.create_shared_method('.to_lower*', TosSpec, [],
    &lambda {|vm| self.downcase! })

  # ["stressed"] .reverse ["desserts"]
  String.create_shared_method('.reverse', TosSpec, [],
    &lambda {|vm| vm.push(self.to_s.reverse.freeze); })

  # ["stressed"*] .reverse* [] #Reverse the string in place.
  StringBuffer.create_shared_method('.reverse*', TosSpec, [],
    &lambda {|vm| self.reverse! })

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

  # [a_string] .shell []
  String.create_shared_method('.shell', TosSpec, [], &lambda {|vm|
    system(self)
  })

  # [a_string] .shell_out [a_string]
  String.create_shared_method('.shell_out', TosSpec, [], &lambda {|vm|
    IO.popen(self, "r") {|io| vm.push(io.read) }
  })

end
