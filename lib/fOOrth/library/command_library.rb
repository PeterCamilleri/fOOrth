# coding: utf-8

#* library/command_library.rb - The utility command fOOrth library.
module XfOOrth

  #The quit out of fOOrth method.
  VirtualMachine.create_shared_method(')quit', MacroSpec,
    [:macro, "raise ForceExit; "])

  #Execute a command to the shell.
  VirtualMachine.create_shared_method(')"', MacroSpec,
    [:macro, "system(vm.pop()); "])

  #Enter debug mode. Warning! This is really verbose!
  VirtualMachine.create_shared_method(')debug', MacroSpec,
    [:macro, "vm.debug = true; "])

  #Display the current fOOrth language version.
  VirtualMachine.create_shared_method(')version', MacroSpec,
    [:macro, 'puts "fOOrth language system version = #{XfOOrth::VERSION}"; '])

  VirtualMachine.create_shared_method(')entries', VmSpec, [], &lambda {|vm|
    entries = SymbolMap.fwd_map.keys.sort
    puts 'Symbol Map Entries = '
    entries.foorth_pretty(vm)
    puts
  })

  Object.create_shared_method(')methods', TosSpec, [], &lambda {|vm|
    if self.foorth_has_exclusive?
      puts 'Exclusive Methods = '
      self.foorth_exclusive.extract_method_names.sort.foorth_pretty(vm)
    end

    puts "#{self.class.foorth_name} Shared Methods = "
    self.class.foorth_shared.extract_method_names.sort.foorth_pretty(vm)
  })

  Class.create_shared_method(')methods', TosSpec, [], &lambda {|vm|
    if self.foorth_has_exclusive?
      puts "#{self.foorth_name} Class Methods = "
      self.foorth_exclusive.extract_method_names.sort.foorth_pretty(vm)
    end

    puts "#{self.foorth_name} Shared Methods = "
    self.foorth_shared.extract_method_names.sort.foorth_pretty(vm)
  })

end
