# coding: utf-8

require_relative 'introspection/symbol_map'
require_relative 'introspection/class'
require_relative 'introspection/object'
require_relative 'introspection/word_specs'

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

  #Get information on a method.
  Class.create_shared_method('.method_info', TosSpec, [], &lambda{|vm|
    symbol, info = SymbolMap.map_info(name = vm.pop)
    results = [["Name", name], info]
    found   = false

    if symbol
      spec, info = map_foorth_shared_info(symbol)

      if spec && !spec.has_tag?(:stub)
        results.concat(info)
        results.concat(spec.get_info)
        found = true
      end

      spec, info = map_foorth_exclusive_info(symbol)

      if spec && !spec.has_tag?(:stub)
        results << ["", ""] if found
        results.concat(info)
        results.concat(spec.get_info)
        found = true
      end

      results << ["Scope", "not found."] unless found
    end

    vm.push(results)
  })

  #The user level command for the above.
  Class.create_shared_method(')method_info"', NosSpec, [], &lambda{|vm|
    foorth_method_info(vm)
    (vm.pop).puts_foorth_bullets($fcpl)
  })

  #Get information on a method.
  Object.create_shared_method('.method_info', TosSpec, [], &lambda{|vm|
    symbol, info = SymbolMap.map_info(name = vm.pop)
    results = [["Name", name], info]
    found   = false

    if symbol
      spec, info = map_foorth_exclusive_info(symbol)

      if spec && !spec.has_tag?(:stub)
        results.concat(info)
        results.concat(spec.get_info)
        found = true
      end

      results << ["Scope", "not found."] unless found
    end

    vm.push(results)
  })

  #The user level command for the above.
  Object.create_shared_method(')method_info"', NosSpec, [], &lambda{|vm|
    foorth_method_info(vm)
    (vm.pop).puts_foorth_bullets($fcpl)
  })

end

