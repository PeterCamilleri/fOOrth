# coding: utf-8

#* library/data_ref_library.rb - The data references (variables) fOOrth library.
module XfOOrth

  #The lambda used to define local variables. fOOrth language definition is:
  # [n] var: lv [], lv = [n]
  Local_Var_Action = lambda {|vm|
    name   = vm.parser.get_word()
    error "F10: Invalid var name #{name}" unless /^[a-z][a-z0-9_]*$/ =~ name
    symbol = XfOOrth::SymbolMap.add_entry(name)
    vm << "#{symbol} = [vm.pop]; "

    #Add a local defn for the local variable.
    vm.context.create_local_method(name, LocalSpec, [:immediate],
      &lambda {|vm| vm << "vm.push(#{symbol}); "} )
  }

  #The lambda used to define local values. fOOrth language definition is:
  # [n] val: lv [], lv = n
  Local_Val_Action = lambda {|vm|
    name   = vm.parser.get_word()
    error "F10: Invalid val name #{name}" unless /^[a-z][a-z0-9_]*$/ =~ name
    symbol = XfOOrth::SymbolMap.add_entry(name)
    vm << "#{symbol} = vm.pop; "

    #Add a local defn for the local variable.
    vm.context.create_local_method(name, LocalSpec, [:immediate],
      &lambda {|vm| vm << "vm.push(#{symbol}); "} )
  }

  # Thread Variables
  # [n] var#: #tv [], Thread.current[#tv] = [n]
  VirtualMachine.create_shared_method('var#:', VmSpec, [:immediate], &lambda {|vm|
    name   = vm.parser.get_word()
    error "F10: Invalid var name #{name}" unless /^#[a-z][a-z0-9_]*$/ =~ name
    symbol = XfOOrth::SymbolMap.add_entry(name)

    if execute_mode?
      vm.data[symbol] = [vm.pop]
    else
      vm << "vm.data[#{symbol.inspect}] = [vm.pop]; "
    end

    vm.create_exclusive_method(name, ThreadVarSpec, [])
  })

  # Thread values.
  # [n] val#: #tv [], Thread.current[#tv] = n
  VirtualMachine.create_shared_method('val#:', VmSpec, [:immediate], &lambda {|vm|
    name   = vm.parser.get_word()
    error "F10: Invalid val name #{name}" unless /^#[a-z][a-z0-9_]*$/ =~ name
    symbol = XfOOrth::SymbolMap.add_entry(name)

    if execute_mode?
      vm.data[symbol] = vm.pop
    else
      vm << "vm.data[#{symbol.inspect}] = vm.pop; "
    end

    vm.create_exclusive_method(name, ThreadVarSpec, [])
  })

  # Global Variables
  # [n] var$: $gv [], $gv = [n]
  VirtualMachine.create_shared_method('var$:', VmSpec, [:immediate], &lambda {|vm|
    name   = vm.parser.get_word()
    error "F10: Invalid var name #{name}" unless /^\$[a-z][a-z0-9_]*$/ =~ name
    symbol = XfOOrth::SymbolMap.add_entry(name)

    if execute_mode?
      eval "#{'$' + symbol.to_s} = [vm.pop]"
    else
      vm << "#{'$' + symbol.to_s} = [vm.pop]; "
    end

    $FOORTH_GLOBALS[symbol] = GlobalVarSpec.new(name, symbol, [])
  })

  # Global Values
  # [n] val$: $gv [], $gv = n
  VirtualMachine.create_shared_method('val$:', VmSpec, [:immediate], &lambda {|vm|
    name   = vm.parser.get_word()
    error "F10: Invalid val name #{name}" unless /^\$[a-z][a-z0-9_]*$/ =~ name
    symbol = XfOOrth::SymbolMap.add_entry(name)

    if execute_mode?
      eval "#{'$' + symbol.to_s} = vm.pop"
    else
      vm << "#{'$' + symbol.to_s} = vm.pop; "
    end

    $FOORTH_GLOBALS[symbol] = GlobalVarSpec.new(name, symbol, [])
  })

end