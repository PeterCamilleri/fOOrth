# coding: utf-8

#Load up some pretty printing support.
require_relative 'formatting/nil'
require_relative 'formatting/object'
require_relative 'formatting/string'
require_relative 'formatting/array'
require_relative 'formatting/hash'
require_relative 'formatting/columns'
require_relative 'formatting/bullets'

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

  symbol = :lines_per_page
  SymbolMap.add_entry('$lines_per_page', symbol)
  $lines_per_page = [25]
  $FOORTH_GLOBALS[symbol] = GlobalVarSpec.new('$lines_per_page', symbol, [])

  symbol = :chars_per_line
  $chars_per_line = [80]
  SymbolMap.add_entry('$chars_per_line', symbol)
  $FOORTH_GLOBALS[symbol] = GlobalVarSpec.new('$chars_per_line', symbol, [])

  #Show the page length.
  VirtualMachine.create_shared_method(')pl', MacroSpec,
    [:macro, 'puts "Page Length = #{$lines_per_page[0]}"; '])

  #Set the page length.
  VirtualMachine.create_shared_method(')set_pl', MacroSpec,
    [:macro, 'puts "New Page Length = #{$lines_per_page[0] = vm.pop}"; '])

  #Show the page width.
  VirtualMachine.create_shared_method(')pw', MacroSpec,
    [:macro, 'puts "Page Width = #{$chars_per_line[0]}"; '])

  #Set the page width.
  VirtualMachine.create_shared_method(')set_pw', MacroSpec,
    [:macro, 'puts "New Page Width = #{$chars_per_line[0] = vm.pop}"; '])

  # [ l 2 3 ... n ] .pp []; pretty print the array!
  Array.create_shared_method('.pp', TosSpec, [], &lambda {|vm|
    puts_foorth_columns($lines_per_page[0], $chars_per_line[0])
  })

  # [ l 2 3 ... n ] .format_columns []; format to strings with columns.
  Array.create_shared_method('.format_columns', TosSpec, [], &lambda {|vm|
    vm.push(format_foorth_columns($lines_per_page[0], $chars_per_line[0]))
  })

  # [ l 2 3 ... n ] .print_columns []; pretty print columns.
  Array.create_shared_method('.print_columns', TosSpec, [], &lambda {|vm|
    puts_foorth_columns($lines_per_page[0], $chars_per_line[0])
  })

  #[["1" "stuff"] ["two" stuff] .format_bullets; format to strings with bullets.
  Array.create_shared_method('.format_bullets', TosSpec, [], &lambda {|vm|
    vm.push(foorth_format_bullets($chars_per_line[0]))
  })

  #[["1" "stuff"] ["two" stuff] .print_bullets; pretty print bullet points.
  Array.create_shared_method('.print_bullets', TosSpec, [], &lambda {|vm|
    puts_foorth_bullets($chars_per_line[0])
  })

  #{ "1" "stuff" -> "two" "stuff" -> } .format_bullets; format to strings with bullets.
  Hash.create_shared_method('.format_bullets', TosSpec, [], &lambda {|vm|
    vm.push(foorth_format_bullets($chars_per_line[0]))
  })

  #{ "1" "stuff" -> "two" "stuff" -> } .print_bullets; pretty print bullet points.
  Hash.create_shared_method('.print_bullets', TosSpec, [], &lambda {|vm|
    puts_foorth_bullets($chars_per_line[0])
  })

end
