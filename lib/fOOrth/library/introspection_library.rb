# coding: utf-8

require_relative 'introspection/symbol_map'
require_relative 'introspection/class'
require_relative 'introspection/object'
require_relative 'introspection/word_specs'
require_relative 'introspection/context'
require_relative 'introspection/vm'

#* library/introspection_library.rb - The fOOrth introspection library.
module XfOOrth

  #Dump the context.
  VirtualMachine.create_shared_method(')context', VmSpec, [],
    &lambda {|vm| vm.context.get_info.foorth_bullets(vm) })

  #Dump the context right NOW!.
  VirtualMachine.create_shared_method(')context!', VmSpec, [:immediate],
    &lambda {|vm| vm.context.get_info.foorth_bullets(vm) })

  # [vm] .dump []
  VirtualMachine.create_shared_method('.dump', TosSpec, [],
    &lambda {|vm| get_info.foorth_bullets(vm) })

  #Dump the virtual machine.
  VirtualMachine.create_shared_method(')vm', VmSpec, [],
    &lambda {|vm| get_info.foorth_bullets(vm) })

  #Dump the virtual machine right NOW!
  VirtualMachine.create_shared_method(')vm!', VmSpec, [:immediate],
    &lambda {|vm| get_info.foorth_bullets(vm) })

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
        (results << ["", ""]).concat(info).concat(spec.get_info)
        found = true
      end

      spec, info = map_foorth_exclusive_info(symbol)

      if spec && !spec.has_tag?(:stub)
        (results << ["", ""]).concat(info).concat(spec.get_info)
        found = true
      end

      results << ["Scope", "not found."] unless found
    end

    vm.push(results)
  })

  #The user level command for the above.
  Class.create_shared_method(')method_info"', NosSpec, [], &lambda{|vm|
    foorth_method_info(vm)
    vm.pop.foorth_bullets(vm)
  })

  #Get information on a method.
  Object.create_shared_method('.method_info', TosSpec, [], &lambda{|vm|
    symbol, info = SymbolMap.map_info(name = vm.pop)
    results = [["Name", name], info]
    found   = false

    if symbol
      spec, info = map_foorth_exclusive_info(symbol)

      if spec && !spec.has_tag?(:stub)
        (results << ["", ""]).concat(info).concat(spec.get_info)
        found = true
      end

      results << ["Scope", "not found."] unless found
    end

    vm.push(results)
  })

  #The user level command for the above.
  Object.create_shared_method(')method_info"', NosSpec, [], &lambda{|vm|
    foorth_method_info(vm)
    vm.pop.foorth_bullets(vm)
  })

  #Scan all classes for information about a method.
  String.create_shared_method('.method_scan', TosSpec, [], &lambda{|vm|
    symbol, info = SymbolMap.map_info(self)
    results = [["Name", self], info]
    found   = false

    symbol && $FOORTH_GLOBALS.values
      .select {|entry| entry.has_tag?(:class)}
      .collect {|spec| spec.new_class}
      .sort {|a,b| a.foorth_name <=> b.foorth_name}
      .each do |klass|
        spec, info = klass.map_foorth_shared_info(symbol, :shallow)
        found |= spec && (results << ["", ""]).concat(info).concat(spec.get_info)

        spec, info = klass.map_foorth_exclusive_info(symbol, :shallow)
        found |= spec && (results << ["", ""]).concat(info).concat(spec.get_info)
      end

    results << ["Scope", "not found in any class."] if symbol && !found

    vm.push(results)
  })

  #The user level command for the above.
  String.create_shared_method(')method_scan"', TosSpec, [], &lambda{|vm|
    foorth_method_scan(vm)
    vm.pop.foorth_bullets(vm)
  })

  #Get this class's lineage in a string.
  Class.create_shared_method('.lineage', TosSpec, [], &lambda{|vm|
    vm.push(lineage.freeze)
  })

  #The user level command for the above.
  Class.create_shared_method(')lineage', TosSpec, [], &lambda{|vm|
    puts lineage
  })

  #Scan a class for stuff.
  Class.create_shared_method('.class_scan', TosSpec, [], &lambda{|vm|
    results = [["Lineage", lineage]]

    if foorth_has_exclusive?
      results.concat([["", ""], ["Methods", "Class"]])

      foorth_exclusive.extract_method_names.sort.each do |name|
        symbol, info = SymbolMap.map_info(name)
        results.concat([["", ""], ["Name", name], info])
        spec, info = map_foorth_exclusive_info(symbol, :shallow)
        results.concat(info).concat(spec.get_info)
      end
    end

    unless foorth_shared.empty?
      results.concat([["", ""], ["Methods", "Shared"]])

      foorth_shared.extract_method_names.sort.each do |name|
        symbol, info = SymbolMap.map_info(name)
        results.concat([["", ""], ["Name", name], info])
        spec, info = map_foorth_shared_info(symbol, :shallow)
        results.concat(info).concat(spec.get_info)
      end
    end

    vm.push(results)
  })

  #The user level command for the above.
  Class.create_shared_method(')class_scan', TosSpec, [], &lambda{|vm|
    foorth_class_scan(vm)
    vm.pop.foorth_bullets(vm)
  })

  #Scan an object for stuff.
  Object.create_shared_method('.object_scan', TosSpec, [], &lambda{|vm|
    vm.push(get_info)
  })

  #The user level command for the above.
  Object.create_shared_method(')object_scan', TosSpec, [], &lambda{|vm|
    get_info.foorth_bullets(vm)
  })


end
