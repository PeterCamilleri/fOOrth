# coding: utf-8

#* library/compile_library.rb - The compile support fOOrth library.
module XfOOrth

  # COLON =======================================

  #The classic colon definition that creates a word in the Virtual Machine class.
  # [] : <name> <stuff omitted> ; []; creates <name> on the VirtualMachine
  VirtualMachine.create_shared_method(':', VmSpec, [],  &lambda {|vm|
    target = VirtualMachine
    name   = vm.parser.get_word()
    type   = VmSpec
    XfOOrth.validate_type(vm, type, name)

    begin_compile_mode(':', vm: vm, &lambda {|vm, src, tags|
      vm.dbg_puts "#{name} => #{src}"
      target.create_shared_method(name, type, tags, &eval(src))
    })

    XfOOrth.add_common_compiler_locals(vm, ':')
  })

  # BANG COLON ==================================

  #A special colon definition that creates an immediate word in the
  #Virtual Machine class.
  # [] !: <name> <stuff omitted> ; []; creates <name> on the VirtualMachine
  VirtualMachine.create_shared_method('!:', VmSpec, [],  &lambda {|vm|
    target = VirtualMachine
    name   = vm.parser.get_word()
    type   = VmSpec
    XfOOrth.validate_type(vm, type, name)

    begin_compile_mode('!:', vm: vm, tags: [:immediate], &lambda {|vm, src, tags|
      vm.dbg_puts "(!) #{name} => #{src}"
      target.create_shared_method(name, type, tags, &eval(src))
    })

    XfOOrth.add_common_compiler_locals(vm, '!:')
  })


  # DOT COLON ===================================

  # [a_class] .: <name> <stuff omitted> ; []; creates <name> on a_class
  Class.create_shared_method('.:', TosSpec, [],  &lambda {|vm|
    target = self
    name   = vm.parser.get_word()
    type   = XfOOrth.name_to_type(name)
    XfOOrth.validate_type(vm, type, name)

    vm.begin_compile_mode('.:', cls: target, &lambda {|vm, src, tags|
      vm.dbg_puts "#{target.foorth_name} #{name} => #{src}"
      target.create_shared_method(name, type, tags, &eval(src))
    })

    XfOOrth.add_common_compiler_locals(vm, '.:')
  })


  # DOT COLON COLON =============================

  # [an_object] .:: <name> <stuff omitted> ; []; creates <name> on an_object
  Object.create_shared_method('.::', TosSpec, [],  &lambda {|vm|
    target = self
    name   = vm.parser.get_word()
    type   = XfOOrth.name_to_type(name)
    XfOOrth.validate_type(vm, type, name)

    vm.begin_compile_mode('.::', obj: target, &lambda {|vm, src, tags|
      vm.dbg_puts "#{target.foorth_name} {name} => #{src}"
      target.create_exclusive_method(name, type, tags, &eval(src))
    })

    XfOOrth.add_common_compiler_locals(vm, '.::')
  })


  # COMMON LOCAL DEFNS ==========================

  #Set up the common local defns.
  #<br>Parameters:
  #* vm - The current virtual machine instance.
  #* ctrl - A list of valid start controls.
  #<br>Endemic Code Smells
  #* :reek:TooManyStatements
  def self.add_common_compiler_locals(vm, ctrl)
    context = vm.context

    #Support for local variables.
    context.create_local_method('local:', [:immediate], &Local_Var_Action)

    #Support for instance variables.
    context.create_local_method('inst:', [:immediate], &Inst_Var_Action)

    #Support for super methods.
    context.create_local_method('super', [:immediate],
      &lambda {|vm| vm << 'super(vm); ' })

    #The standard end-compile adapter word: ';' semi-colon.
    context.create_local_method(';', [:immediate],
      &lambda {|vm| vm.end_compile_mode([ctrl]) })
  end

  #Determine the type of method being created. This only applies to non-vm
  #methods as vm methods are all of type VmSpec.
  #<br>Parameters
  #*name - The name of the method to be created.
  #<Returns>
  #* The class of the spec to be used for this method.
  def self.name_to_type(name)
    case name[0]
    when '.'
      TosSpec

    when '~'
      SelfSpec

    when /[A-Z]|\$|\#|\@/
      error "Invalid name for a method: #{name}"

    else
      NosSpec
    end
  end

  #Compare the new method's spec against the specs of other methods of the
  #same name. If no specs exist, create one on Object if the new spec is not
  #a virtual machine spec.
  #<br>Parameters
  #*vm - The current virtual machine.
  #*type - The class of the method to be created.
  #*name - The name of the method to be created.
  def self.validate_type(vm, type, name)
    if (spec = vm.context.map(name))
      if spec.class != type
        error "Spec type mismatch #{spec.foorth_name} vs #{type.foorth_name}"
      end
    else
      Object.create_shared_method(name, type, [:stub]) unless type == VmSpec
    end

  end

end