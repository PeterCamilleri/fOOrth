# coding: utf-8

#* library/compile_library.rb - The compile support fOOrth library.
module XfOOrth

  #The classic colon definition that creates a word in the Virtual Machine class.
  VirtualMachine.create_shared_method(':', VmWordSpec, [],  &lambda {|vm|
    name   = vm.parser.get_word()
    target = VirtualMachine

    begin_compile_mode(':', vm: vm, &lambda {|vm, src|
      puts "#{name} => #{src}" if vm.debug
      target.create_shared_method(name, VmWordSpec, [], &eval(src))
    })
  })

  #A colon definition that creates a word in the specified class.
  compile_action = lambda {|vm|
    name   = vm.parser.get_word()
    target = self

    error "Name Error: All non-Object mapped methods must begin with a '.'" unless
      (target.name == 'Object') || (name[0] == '.') || XfOOrth.object_maps_name(name)

    vm.begin_compile_mode('x::', cls: target, &lambda {|vm, src|
      puts "#{target.name} #{name} => #{src}" if vm.debug
      target.create_shared_method(name, PublicWordSpec, [], &eval(src))
    })
  }

  class_class.create_shared_method('.::', PublicWordSpec, [],  &compile_action)

  #The standard end-compile adapter word: ';' semi-colon.
  VirtualMachine.create_shared_method(';', VmWordSpec, [:immediate],
    &lambda {|vm| end_compile_mode([':', 'x::']) })

  #The immediate end-compile adapter word: ;immediate.
  VirtualMachine.create_shared_method(';immediate', VmWordSpec, [:immediate],
    &lambda {|vm| end_compile_mode([':', 'x::']).tags << :immediate })

end