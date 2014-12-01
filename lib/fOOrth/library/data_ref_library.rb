# coding: utf-8

#* library/data_ref_library.rb - The data references (variables) fOOrth library.
module XfOOrth

  # Some basic data access words.
  # [pointer] @ [value]
  Object.create_shared_method('@', MacroSpec,
    [:macro, "vm.poke(vm.peek[0] ); "])

  # [value pointer] ! [], variable = [value]
  VirtualMachine.create_shared_method('!', VmSpec, [],
    &lambda {|vm| val, ptr = popm(2); ptr[0] = val; })

  #The lambda used to define local variables. fOOrth language definition is:
  # [n] local: lv [], lv = n.to_foorth_p
  Local_Var_Action = lambda {|vm|
    name   = vm.parser.get_word()
    error "Invalid var name #{name}" unless /^[a-z][a-z0-9_]*$/ =~ name
    symbol = XfOOrth::SymbolMap.add_entry(name)
    vm << "#{symbol} = vm.pop.to_foorth_p; "

    #Add a local defn for the local variable.
    vm.context.create_local_method(name, [:immediate],
      &lambda {|vm| vm << "vm.push(#{symbol}); "} )
  }

  #The lambda used to define instance variables. fOOrth language definition is:
  # [n] inst: @iv [], @iv = n.to_foorth_p
  Inst_Var_Action = lambda { |vm|
    name   = vm.parser.get_word()
    error "Invalid var name #{name}" unless /^@[a-z][a-z0-9_]*$/ =~ name
    symbol = XfOOrth::SymbolMap.add_entry(name)
    vm << "#{'@'+(symbol.to_s)} = vm.pop.to_foorth_p; "

    #Add a defn for the instance variable.
    vm.context.recvr.create_shared_method(name, InstanceVarSpec, [])
  }

  # Thread Variables
  # [n] thread: #tv [], Thread.current[#tv] = n.to_foorth_p
  VirtualMachine.create_shared_method('thread:', VmSpec, [], &lambda {|vm|
    name   = vm.parser.get_word()
    error "Invalid var name #{name}" unless /^#[a-z][a-z0-9_]*$/ =~ name
    symbol = XfOOrth::SymbolMap.add_entry(name)
    Thread.current[symbol] = vm.pop.to_foorth_p

    vm.create_exclusive_method(name, ThreadVarSpec, [])
  })

  # Global Variables
  # [n] global: $gv [], $gv = n.to_foorth_p
  VirtualMachine.create_shared_method('global:', VmSpec, [], &lambda {|vm|
    name   = vm.parser.get_word()
    error "Invalid var name #{name}" unless /^\$[a-z][a-z0-9_]*$/ =~ name
    symbol = XfOOrth::SymbolMap.add_entry(name)
    eval "#{'$' + symbol.to_s} = vm.pop.to_foorth_p"

    $FOORTH_GLOBALS[symbol] = GlobalVarSpec.new(name, symbol, [])
  })


end