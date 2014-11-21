# coding: utf-8

#* library/compile_library.rb - The compile support fOOrth library.
module XfOOrth

  # COLON =======================================

  #The classic colon definition that creates a word in the Virtual Machine class.
  VirtualMachine.create_shared_method(':', VmSpec, [],  &lambda {|vm|
    target = VirtualMachine
    name   = vm.parser.get_word()
    type   = VmSpec

    begin_compile_mode(':', vm: vm, &lambda {|vm, src, tags|
      puts "#{name} => #{src}" if vm.debug
      target.create_shared_method(name, type, tags, &eval(src))
    })

    XfOOrth.add_common_compiler_locals(vm, ':')
  })


  # DOT COLON COLON =============================

  #An array of types allowed for a method.
  AllowedMethodTypes = [TosSpec, SelfSpec, NosSpec]

  #Determine the type of word being created.
  def self.name_to_type(name)
    case name[0]
    when '.'
      TosSpec

    when '~'
      SelfSpec

    else
      type = (symbol = XfOOrth::SymbolMap.map(name))   &&
             (spec = Object.map_foorth_shared(symbol)) &&
             spec.class
      type = nil unless AllowedMethodTypes.include?(type)
      error "Invalid name for a method: #{name}" unless type
      type
    end
  end

  #A colon definition that creates a word in the specified class.
  compile_action = lambda {|vm|
    target = self
    name   = vm.parser.get_word()
    type   = XfOOrth.name_to_type(name)

    vm.begin_compile_mode('.::', cls: target, &lambda {|vm, src, tags|
      puts "#{target.name} #{name} => #{src}" if vm.debug
      target.create_shared_method(name, type, tags, &eval(src))
    })

    XfOOrth.add_common_compiler_locals(vm, '.::')
  }

  Class.create_shared_method('.::', TosSpec, [],  &compile_action)


  # COMMON LOCAL DEFNS ==========================

  #Set up the common local defns.
  #<br>Parameters:
  #* vm - The current virtual machine instance.
  #* ctrl - A list of valid start controls.
  def self.add_common_compiler_locals(vm, ctrl)
    context = vm.context

    #Support for local variables.
    context.create_local_method('local:', [:immediate], &Local_Var_Action)

    #The standard end-compile adapter word: ';' semi-colon.
    context.create_local_method(';', [:immediate],
      &lambda {|vm| vm.end_compile_mode([ctrl], []) })

    #The immediate end-compile adapter word: ;immediate.
    context.create_local_method(';immediate', [:immediate],
      &lambda {|vm| vm.end_compile_mode([ctrl], [:immediate])})
  end

end