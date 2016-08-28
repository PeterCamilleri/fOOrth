# coding: utf-8

#* library/introspection_library.rb - The fOOrth introspection library.
module XfOOrth

  #Dump the context.
  VirtualMachine.create_shared_method(')context', VmSpec, [],
    &lambda {|vm| vm.context.debug_dump(vm) })

  #Dump the context right NOW!.
  VirtualMachine.create_shared_method(')context!', VmSpec, [:immediate],
    &lambda {|vm| vm.context.debug_dump(vm) })

  #Dump the virtual machine.
  VirtualMachine.create_shared_method(')vm', VmSpec, [],
    &lambda {|vm| vm.debug_dump })

  #Dump the virtual machine right NOW!
  VirtualMachine.create_shared_method(')vm!', VmSpec, [:immediate],
    &lambda {|vm| vm.debug_dump })

  #Map a symbol entry
  VirtualMachine.create_shared_method(')map"', VmSpec, [], &lambda {|vm|
    str = vm.pop.to_s
    puts "#{str} => #{(SymbolMap.map(str).to_s)}"
  })

  #Unmap a symbol entry
  VirtualMachine.create_shared_method(')unmap"', VmSpec, [], &lambda {|vm|
    str = vm.pop.to_s
    puts "#{str} <= #{(SymbolMap.unmap(str.to_sym).to_s)}"
  })

end

