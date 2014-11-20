# coding: utf-8

#* library/data_ref_library.rb - The data references (variables) fOOrth library.
module XfOOrth

  # Some basic data access words.
  # [pointer] @ [value]
  Object.create_shared_method('@', MacroSpec,
    ["vm.push(vm.pop[0] ); "])

  # [value pointer] ! []
  VirtualMachine.create_shared_method('!', VmSpec, [],
    &lambda {|vm| v, p = popm(2); p[0] = v; })

  # Local Variables
  Local_Var_Action = lambda {|vm|
    name   = vm.parser.get_word()
    error "Invalid var name #{name}" unless /^[a-z][a-z0-9_]*$/ =~ name
    symbol = XfOOrth::SymbolMap.add_entry(name)
    vm << "#{symbol} = [nil]; "

    #Add a local defn for the local variable.
    vm.context.create_local_method(name, [:immediate],
      &lambda {|vm| vm << "vm.push(#{symbol}); "} )
  }

end