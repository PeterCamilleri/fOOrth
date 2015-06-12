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

  #The lambda used to define local variables. fOOrth language definition is:
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

  #The lambda used to define instance variables. fOOrth language definition is:
  # [n] var@: @iv [], @iv = [n]
  Inst_Var_Action = lambda { |vm|
    name   = vm.parser.get_word()
    error "F10: Invalid var name #{name}" unless /^@[a-z][a-z0-9_]*$/ =~ name
    symbol = XfOOrth::SymbolMap.add_entry(name)
    vm << "#{'@'+(symbol.to_s)} = [vm.pop]; "

    #Add a defn for the instance variable.
    vm.context.recvr.create_shared_method(name, InstanceVarSpec, [])
  }

  #The lambda used to define instance variables. fOOrth language definition is:
  # [n] val@: @iv [], @iv = n
  Inst_Val_Action = lambda { |vm|
    name   = vm.parser.get_word()
    error "F10: Invalid val name #{name}" unless /^@[a-z][a-z0-9_]*$/ =~ name
    symbol = XfOOrth::SymbolMap.add_entry(name)
    vm << "#{'@'+(symbol.to_s)} = vm.pop; "

    #Add a defn for the instance variable.
    vm.context.recvr.create_shared_method(name, InstanceVarSpec, [])
  }

  # Thread Variables
  # [n] var#: #tv [], Thread.current[#tv] = [n]
  VirtualMachine.create_shared_method('var#:', VmSpec, [], &lambda {|vm|
    name   = vm.parser.get_word()
    error "F10: Invalid var name #{name}" unless /^#[a-z][a-z0-9_]*$/ =~ name
    symbol = XfOOrth::SymbolMap.add_entry(name)
    @data[symbol] = [vm.pop]

    vm.create_exclusive_method(name, ThreadVarSpec, [])
  })

  # [n] val#: #tv [], Thread.current[#tv] = n
  VirtualMachine.create_shared_method('val#:', VmSpec, [], &lambda {|vm|
    name   = vm.parser.get_word()
    error "F10: Invalid val name #{name}" unless /^#[a-z][a-z0-9_]*$/ =~ name
    symbol = XfOOrth::SymbolMap.add_entry(name)
    @data[symbol] = vm.pop

    vm.create_exclusive_method(name, ThreadVarSpec, [])
  })

  # Global Variables
  # [n] var$: $gv [], $gv = [n]
  VirtualMachine.create_shared_method('var$:', VmSpec, [], &lambda {|vm|
    name   = vm.parser.get_word()
    error "F10: Invalid var name #{name}" unless /^\$[a-z][a-z0-9_]*$/ =~ name
    symbol = XfOOrth::SymbolMap.add_entry(name)
    eval "#{'$' + symbol.to_s} = [vm.pop]"

    $FOORTH_GLOBALS[symbol] = GlobalVarSpec.new(name, symbol, [])
  })

  # Global Variables
  # [n] val$: $gv [], $gv = n
  VirtualMachine.create_shared_method('val$:', VmSpec, [], &lambda {|vm|
    name   = vm.parser.get_word()
    error "F10: Invalid val name #{name}" unless /^\$[a-z][a-z0-9_]*$/ =~ name
    symbol = XfOOrth::SymbolMap.add_entry(name)
    eval "#{'$' + symbol.to_s} = vm.pop"

    $FOORTH_GLOBALS[symbol] = GlobalVarSpec.new(name, symbol, [])
  })

end