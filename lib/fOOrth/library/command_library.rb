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

  #Start an Interactive RuBy session (IRB)
  VirtualMachine.create_shared_method(')irb', VmSpec, [], &lambda {|vm|
    require 'irb'
    require 'irb/completion'

    puts
    puts "Starting an IRB console for fOOrth."
    puts "Enter quit to return to fOOrth."
    puts

    ARGV.clear
    IRB.start
  })

  #Start a Pry session (IRB)
  VirtualMachine.create_shared_method(')pry', VmSpec, [], &lambda {|vm|
    require 'pry'

    puts
    puts "Starting an PRY console for fOOrth."
    puts "Enter quit to return to fOOrth."
    puts

    ARGV.clear
    Pry.start
  })

  #Get the VM timer start time.
  VirtualMachine.create_shared_method(')start', VmSpec, [], &lambda {|vm|
    puts "Start time is #{vm.start_time}"
  })

  #Reset the VM timer start time.
  VirtualMachine.create_shared_method(')restart', VmSpec, [], &lambda {|vm|
    puts "Start time reset to #{(vm.start_time = Time.now)}"
  })

  #Display the elapsed time.
  VirtualMachine.create_shared_method(')elapsed', VmSpec, [], &lambda {|vm|
    puts "Elapsed time is #{Time.now - vm.start_time} seconds"
  })

  #What time is it now?
  VirtualMachine.create_shared_method(')time', VmSpec, [], &lambda {|vm|
    puts "It is now: #{Time.now.strftime(TimeFormat)}"
  })

  #Load the file as source code.
  VirtualMachine.create_shared_method(')load"', VmSpec, [], &lambda {|vm|
    start_time = Time.now
    file_name = vm.pop.to_s

    if File.extname(file_name) == ''
      file_name = file_name + '.foorth'
    end

    if File.exists?(file_name)
      puts "Loading file: #{file_name}"
    else
      error "F50: Unable to locate file #{file_name}"
    end

    vm.process_file(file_name.freeze)

    puts "Completed in #{Time.now - start_time} seconds"
  })

  #Display the current fOOrth language version.
  VirtualMachine.create_shared_method(')version', MacroSpec,
    [:macro, 'puts "fOOrth language system version = #{XfOOrth::VERSION}"; '])

  #Dump the SymbolMap entries.
  VirtualMachine.create_shared_method(')entries', VmSpec, [], &lambda {|vm|
    entries = SymbolMap.forward_map.keys.sort
    puts 'Symbol Map Entries = '
    entries.foorth_columns(vm)
    puts
  })

  #List the methods defined for this object.
  Object.create_shared_method(')methods', TosSpec, [], &lambda {|vm|
    if foorth_has_exclusive?
      puts '#{foorth_name} Exclusive Methods = '
      foorth_exclusive.extract_method_names.sort.foorth_columns(vm)
    end

    my_class = self.class

    puts "#{my_class.foorth_name} Shared Methods = "
    my_class.foorth_shared.extract_method_names.sort.foorth_columns(vm)
  })

  #List the methods defined for this class.
  Class.create_shared_method(')methods', TosSpec, [], &lambda {|vm|
    if foorth_has_exclusive?
      puts "#{foorth_name} Class Methods = "
      foorth_exclusive.extract_method_names.sort.foorth_columns(vm)
    end

    puts "#{foorth_name} Shared Methods = "
    foorth_shared.extract_method_names.sort.foorth_columns(vm)
  })

  #List the stubs defined for this class.
  Class.create_shared_method(')stubs', TosSpec, [], &lambda {|vm|
    if foorth_has_exclusive?
      puts "#{foorth_name} Class Stubs = "
      foorth_exclusive.extract_method_names(:stubs).sort.foorth_columns(vm)
    end

    puts "#{foorth_name} Shared Stubs = "
    foorth_shared.extract_method_names(:stubs).sort.foorth_columns(vm)
  })


  #List the classes defined in fOOrth.
  VirtualMachine.create_shared_method(')classes', VmSpec, [], &lambda {|vm|
    $FOORTH_GLOBALS.values
      .select {|entry| entry.has_tag?(:class)}
      .collect {|spec| spec.new_class.foorth_name}
      .sort
      .foorth_columns(vm)
  })

  #List the globals defined in fOOrth.
  VirtualMachine.create_shared_method(')globals', VmSpec, [], &lambda {|vm|
    $FOORTH_GLOBALS.keys
      .select  {|key| !($FOORTH_GLOBALS[key].has_tag?(:class))}
      .collect {|key| "#{XfOOrth::SymbolMap.unmap(key)}"}
      .sort
      .foorth_columns(vm)
  })

  #List the virtual machine methods
  #List the methods defined for this object.
  VirtualMachine.create_shared_method(')words', VmSpec, [], &lambda {|vm|
    if vm.foorth_has_exclusive?
      puts "#{foorth_name} Exclusive Methods = "
      vm.foorth_exclusive.extract_method_names.sort.foorth_columns(vm)
    end

    my_class = vm.class

    puts "#{my_class.foorth_name} Shared Methods = "
    my_class.foorth_shared.extract_method_names.sort.foorth_columns(vm)
  })

  VirtualMachine.create_shared_method(')threads', VmSpec, [], &lambda {|vm|
    puts Thread.list.map {|thread| "#{thread} vm = <#{thread[:vm].name}>"}
  })
end
