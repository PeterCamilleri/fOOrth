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

  #Leave debug mode.
  VirtualMachine.create_shared_method(')nodebug', MacroSpec,
    [:macro, "vm.debug = false; "])

  #Enter show stack mode.
  VirtualMachine.create_shared_method(')show', MacroSpec,
    [:macro, "vm.show_stack = true; "])

  #Leave show stack mode.
  VirtualMachine.create_shared_method(')noshow', MacroSpec,
    [:macro, "vm.show_stack = false; "])

  #Dump the context.
  VirtualMachine.create_shared_method(')context', VmSpec, [],
    &lambda {|vm| vm.context.debug_dump(vm) })

  #Dump the context right NOW!.
  VirtualMachine.create_shared_method(')context!', VmSpec, [:immediate],
    &lambda {|vm| vm.context.debug_dump(vm) })

  #Load the file as source code.
  VirtualMachine.create_shared_method(')load"', VmSpec, [], &lambda{|vm|
    start_time = Time.now
    file_name = vm.pop.to_s

    if File.extname(file_name) == ''
      file_name = file_name + '.foorth'
    end

    if File.exists?(file_name)
      puts "Loading file: #{file_name}"
    else
      error "Unable to locate file #{file_name}"
    end

    vm.process_file(file_name)

    puts "Completed in #{Time.now - start_time} seconds"
  })

  #Display the current fOOrth language version.
  VirtualMachine.create_shared_method(')version', MacroSpec,
    [:macro, 'puts "fOOrth language system version = #{XfOOrth::VERSION}"; '])

  #Dump the SymbolMap entries.
  VirtualMachine.create_shared_method(')entries', VmSpec, [], &lambda {|vm|
    entries = SymbolMap.fwd_map.keys.sort
    puts 'Symbol Map Entries = '
    entries.foorth_pretty(vm)
    puts
  })

  #List the methods defined for this object.
  Object.create_shared_method(')methods', TosSpec, [], &lambda {|vm|
    if self.foorth_has_exclusive?
      puts 'Exclusive Methods = '
      self.foorth_exclusive.extract_method_names.sort.foorth_pretty(vm)
    end

    puts "#{self.class.foorth_name} Shared Methods = "
    self.class.foorth_shared.extract_method_names.sort.foorth_pretty(vm)
  })

  #List the methods defined for this class.
  Class.create_shared_method(')methods', TosSpec, [], &lambda {|vm|
    if self.foorth_has_exclusive?
      puts "#{self.foorth_name} Class Methods = "
      self.foorth_exclusive.extract_method_names.sort.foorth_pretty(vm)
    end

    puts "#{self.foorth_name} Shared Methods = "
    self.foorth_shared.extract_method_names.sort.foorth_pretty(vm)
  })

  #List the stubs defined for this class.
  Class.create_shared_method(')stubs', TosSpec, [], &lambda {|vm|
    if self.foorth_has_exclusive?
      puts "#{self.foorth_name} Class Stubs = "
      self.foorth_exclusive.extract_method_names(:stubs).sort.foorth_pretty(vm)
    end

    puts "#{self.foorth_name} Shared Stubs = "
    self.foorth_shared.extract_method_names(:stubs).sort.foorth_pretty(vm)
  })


  #List the classes defined in fOOrth.
  VirtualMachine.create_shared_method(')classes', VmSpec, [], &lambda {|vm|
    $FOORTH_GLOBALS.values.
      select {|entry| entry.has_tag?(:class)}.
      collect {|spec| spec.new_class.foorth_name}.
      sort.
      foorth_pretty(vm)
  })

  #List the globals defined in fOOrth.
  VirtualMachine.create_shared_method(')globals', VmSpec, [], &lambda {|vm|
    $FOORTH_GLOBALS.keys.
      select {|key| !($FOORTH_GLOBALS[key].has_tag?(:class))}.
      collect {|key| "#{XfOOrth::SymbolMap.unmap(key)} (#{key.inspect})"}.
      foorth_pretty(vm)
  })

  #List the virtual machine methods
  #List the methods defined for this object.
  VirtualMachine.create_shared_method(')words', VmSpec, [], &lambda {|vm|
    if vm.foorth_has_exclusive?
      puts 'Exclusive Methods = '
      vm.foorth_exclusive.extract_method_names.sort.foorth_pretty(vm)
    end

    puts "#{vm.class.foorth_name} Shared Methods = "
    vm.class.foorth_shared.extract_method_names.sort.foorth_pretty(vm)
  })

  VirtualMachine.create_shared_method(')threads', VmSpec, [], &lambda {|vm|
    Thread.list.
      collect {|thrd| "#{thrd} vm = <#{thrd[:vm].name}>" }.
      foorth_pretty(vm)
  })
end
