# coding: utf-8

#Load up some pretty printing support.
require_relative 'pretty/pretty_columns'
require_relative 'pretty/pretty_bullets'

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
    &lambda {|vm| poke(MiniReadline.readline(peek.to_s, true).freeze); })

  #Get a string from the console.
  # "prompt" [] .accept [string]; gets a string from the console.
  String.create_shared_method('.accept', TosSpec, [],
    &lambda{|vm|  vm.push(MiniReadline.readline(self, true))})

  $fcpl = 80 #fOOrth Character Per Line
  $flpp = 25 #fOOrth Lines Per Page

  #Show the page length.
  VirtualMachine.create_shared_method(')pl', MacroSpec,
    [:macro, 'puts "Page Length = #{$flpp}"; '])

  #Set the page length.
  VirtualMachine.create_shared_method(')set_pl', MacroSpec,
    [:macro, 'puts "New Page Length = #{$flpp = vm.pop}"; '])

  #Show the page width.
  VirtualMachine.create_shared_method(')pw', MacroSpec,
    [:macro, 'puts "Page Length = #{$fcpl}"; '])

  #Set the page width.
  VirtualMachine.create_shared_method(')set_pw', MacroSpec,
    [:macro, 'puts "New Page Length = #{$fcpl = vm.pop}"; '])

  # [ l 2 3 ... n ] .pp []; pretty print the array!
  Array.create_shared_method('.pp', TosSpec, [], &lambda {|vm|
    puts_foorth_columnized($flpp, $fcpl)
  })

end
