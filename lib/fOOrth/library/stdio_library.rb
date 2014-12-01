# coding: utf-8

#* library/stdio_library.rb - The standard I/O fOOrth library.
module XfOOrth

  # Some basic console I/O words.
  #[obj] . []; print out the object as a string.
  Object.create_shared_method('.', TosSpec, [],
    &lambda {|vm| print self.to_s})

  #Print out a string.
  # [] ."string" []; prints out the string.
  VirtualMachine.create_shared_method('."', VmSpec, [],
    &lambda {|vm| print pop.to_s})

  #Force a new line.
  # [] .cr []; prints a new line.
  VirtualMachine.create_shared_method('.cr', MacroSpec,
    [:macro, "puts; "])

  #Force a space.
  # [] space []; prints a space
  VirtualMachine.create_shared_method('space', MacroSpec,
    [:macro, "print ' '; "])

  #Force multiple spaces.
  # [n] spaces []; prints n spaces.
  VirtualMachine.create_shared_method('spaces', MacroSpec,
    [:macro, "print ' ' * vm.pop(); "])

  # Print out a single character.
  #[obj] emit []; print out the object as a character.
  Object.create_shared_method('emit', TosSpec, [],
    &lambda {|vm| print self.to_foorth_c})

  #Get a string from the console.
  # [] accept [string]; gets a string from the console.
  VirtualMachine.create_shared_method('accept', VmSpec, [],
    &lambda {|vm| push(Readline.readline('? ', true)); })

  #Get a string from the console.
  # [] accept"prompt" [string]; gets a string from the console.
  VirtualMachine.create_shared_method('accept"', VmSpec, [],
    &lambda {|vm| poke(Readline.readline(peek.to_s, true)); })

end
