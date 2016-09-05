# coding: utf-8

require_relative 'introspection/symbol_map'
require_relative 'introspection/class'
require_relative 'introspection/object'
require_relative 'introspection/word_specs'
require_relative 'introspection/context'

#* library/introspection_library.rb - The fOOrth introspection library.
module XfOOrth

  #Dump the context.
  VirtualMachine.create_shared_method(')context', VmSpec, [],
    &lambda {|vm| vm.context.get_info.foorth_bullets(vm) })

  #Dump the context right NOW!.
  VirtualMachine.create_shared_method(')context!', VmSpec, [:immediate],
    &lambda {|vm| vm.context.get_info.foorth_bullets(vm) })

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
    vm.pop.foorth_bullets(vm)
  })

  #Scan all classes for information about a method.
  String.create_shared_method('.method_scan', TosSpec, [], &lambda{|vm|
    symbol, info = SymbolMap.map_info(self)
    results = [["Name", self], info]
    found   = false

    if symbol

    $FOORTH_GLOBALS.values
      .select {|entry| entry.has_tag?(:class)}
      .collect {|spec| spec.new_class}
      .sort {|a,b| a.foorth_name <=> b.foorth_name}
      .each do |klass|
        spec, info = klass.map_foorth_shared_info(symbol, :shallow)

        if spec
          results << ["", ""]
          results.concat(info)
          results.concat(spec.get_info)
          found = true
        end

        spec, info = klass.map_foorth_exclusive_info(symbol, :shallow)

        if spec
          results << ["", ""]
          results.concat(info)
          results.concat(spec.get_info)
          found = true
        end
      end

      results << ["Scope", "not found in any class."] unless found
    end

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
      results << ["", ""]
      results << ["Class", ""]

      foorth_exclusive.extract_method_names.sort.each do |name|
        results << ["", ""]
        results << ["Name", name]
        symbol, info = SymbolMap.map_info(name)
        results.concat(info)
        spec, info = map_foorth_exclusive_info(symbol, :shallow)
        results.concat(info)
        results.concat(spec.get_info)
      end
    end

    results << ["", ""]
    results << ["Shared", ""]
    foorth_shared.extract_method_names.sort.each do |name|
      results << ["", ""]
      results << ["Name", name]
      symbol, info = SymbolMap.map_info(name)
      results << info
      spec, info = map_foorth_shared_info(symbol, :shallow)
      results.concat(info)
      results.concat(spec.get_info)
    end

    vm.push(results)
  })

  #The user level command for the above.
  Class.create_shared_method(')class_scan', TosSpec, [], &lambda{|vm|
    foorth_class_scan(vm)
    vm.pop.foorth_bullets(vm)
  })

end
