# coding: utf-8

require_relative 'introspection/symbol_map'
require_relative 'introspection/class'
require_relative 'introspection/object'
require_relative 'introspection/string'
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

  #Dump the virtual machine.
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
  Object.create_shared_method('.method_info', TosSpec, [],
    &lambda{|vm| vm.push(foorth_method_info(vm.pop)) })

  #Get information on a method.
  Object.create_shared_method(')method_info"', NosSpec, [],
    &lambda{|vm| foorth_method_info(vm.pop).foorth_bullets(vm) })

  #Scan all classes for information about a method.
  String.create_shared_method('.method_scan', TosSpec, [],
    &lambda{|vm| vm.push(foorth_method_scan) })

  #Scan all classes for information about a method.
  String.create_shared_method(')method_scan"', TosSpec, [],
    &lambda{|vm| foorth_method_scan.foorth_bullets(vm) })

  #Get this class's lineage in a string.
  Object.create_shared_method('.lineage', TosSpec, [],
    &lambda{|vm| vm.push(lineage.freeze) })

  #Print this class's lineage.
  Object.create_shared_method(')lineage', TosSpec, [],
    &lambda{|vm| puts lineage })

  #Scan an object for stuff.
  Object.create_shared_method('.scan', TosSpec, [],
    &lambda{|vm| vm.push(get_info) })

  #Scan an object for stuff.
  Object.create_shared_method(')scan', TosSpec, [],
    &lambda{|vm| get_info.foorth_bullets(vm) })

end
