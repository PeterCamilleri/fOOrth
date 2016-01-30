# coding: utf-8

#* library/stdio_library.rb - The standard I/O fOOrth library.
module XfOOrth

  # Some basic console I/O words.
  #[obj] . []; print out the object as a string.
  Object.create_shared_method('.', TosSpec, [], &lambda {|vm|
    self.to_foorth_s(vm)
    print vm.pop
  })

  #Print out a string.
  # [] ."string" []; prints out the string.
  String.create_shared_method('."', TosSpec, [], &lambda {|vm|
    print self
  })

  #Force a new line.
  # [] cr []; prints a new line.
  VirtualMachine.create_shared_method('cr', MacroSpec,
    [:macro, "puts; "])

  #Force a space.
  # [] space []; prints a space
  VirtualMachine.create_shared_method('space', MacroSpec,
    [:macro, "print ' '; "])

  #Force multiple spaces.
  # [n] spaces []; prints n spaces.
  VirtualMachine.create_shared_method('spaces', MacroSpec,
    [:macro, "print ' ' * Integer.foorth_coerce(vm.pop()); "])

  #Print out a single character.
  #[obj] .emit []; print out the object as a character.
  Numeric.create_shared_method('.emit', TosSpec, [],
    &lambda {|vm| print self.to_foorth_c})
  String.create_shared_method('.emit', TosSpec, [],
    &lambda {|vm| print self.to_foorth_c})
  Complex.create_shared_method('.emit', TosSpec, [:stub])

  #Get a string from the console.
  # [] accept [string]; gets a string from the console.
  VirtualMachine.create_shared_method('accept', VmSpec, [],
    &lambda {|vm| push(MiniReadline.readline('? ', true)); })

  #Get a string from the console.
  # [] accept"prompt" [string]; gets a string from the console.
  VirtualMachine.create_shared_method('accept"', VmSpec, [],
    &lambda {|vm| poke(MiniReadline.readline(peek.to_s, true)); })

  #Get a string from the console.
  # "prompt" [] .accept [string]; gets a string from the console.
  String.create_shared_method('.accept', TosSpec, [],
    &lambda{|vm|  vm.push(MiniReadline.readline(self, true))})
end
