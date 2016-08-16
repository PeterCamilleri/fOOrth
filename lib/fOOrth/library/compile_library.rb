# coding: utf-8

#* library/compile_library.rb - The compile support fOOrth library.
module XfOOrth

  # COLON =======================================

  #The classic colon definition that creates a word in the Virtual Machine class.
  # [] : <name> <stuff omitted> ; []; creates <name> on the VirtualMachine
  VirtualMachine.create_shared_method(':', VmSpec, [:immediate],  &lambda {|vm|
    if execute_mode?
      target = VirtualMachine
      name   = vm.parser.get_word()
      type   = VmSpec
      XfOOrth.validate_type(vm, type, name)

      begin_compile_mode(':', vm: vm, &lambda {|vm, src, tags|
        vm.dbg_puts "#{name} => #{src}"
        target.create_shared_method(name, type, tags, &eval(src))
      })

      XfOOrth.add_common_compiler_locals(vm, ':')
    else
      delayed_compile_mode(':')
    end
  })

  # BANG COLON ==================================

  #A special colon definition that creates an immediate word in the
  #Virtual Machine class.
  # [] !: <name> <stuff omitted> ; []; creates <name> on the VirtualMachine
  VirtualMachine.create_shared_method('!:', VmSpec, [:immediate],  &lambda {|vm|
    if execute_mode?
      target = VirtualMachine
      name   = vm.parser.get_word()
      type   = VmSpec
      XfOOrth.validate_type(vm, type, name)

      begin_compile_mode('!:', vm: vm, tags: [:immediate], &lambda {|vm, src, tags|
        vm.dbg_puts "(!) #{name} => #{src}"
        target.create_shared_method(name, type, tags, &eval(src))
      })

      XfOOrth.add_common_compiler_locals(vm, '!:')
    else
      delayed_compile_mode('!:')
    end
  })


  # DOT COLON ===================================

  # [a_class] .: <name> <stuff omitted> ; []; creates <name> on a_class
  VirtualMachine.create_shared_method('.:', VmSpec, [:immediate],  &lambda {|vm|
    if execute_mode?
      target = vm.pop
      error "F13: The target of .: must be a class" unless target.is_a?(Class)

      name   = vm.parser.get_word()
      type   = XfOOrth.name_to_type(name)
      XfOOrth.validate_type(vm, type, name)
      XfOOrth.validate_string_method(type, target, name)

      begin_compile_mode('.:', cls: target, &lambda {|vm, src, tags|
        vm.dbg_puts "#{target.foorth_name} #{name} => #{src}"
        target.create_shared_method(name, type, tags, &eval(src))
      })

      XfOOrth.add_common_compiler_locals(vm, '.:')
      XfOOrth.add_dot_colon_locals(vm.context)
    else
      delayed_compile_mode('.:')
    end
  })

  DC_VAR = lambda {|vm|
    var_name = vm.parser.get_word()

    unless /^@[a-z][a-z0-9_]*$/ =~ var_name
      error "F10: Invalid var name #{var_name}"
    end

    var_symbol = XfOOrth::SymbolMap.add_entry(var_name)
    vm << "#{'@'+(var_symbol.to_s)} = [vm.pop]; "

    vm.context[:cls].create_shared_method(var_name, InstanceVarSpec, [])
  }

  DC_VAL = lambda {|vm|
    val_name = vm.parser.get_word()

    unless /^@[a-z][a-z0-9_]*$/ =~ val_name
      error "F10: Invalid val name #{val_name}"
    end

    val_symbol = XfOOrth::SymbolMap.add_entry(val_name)
    vm << "#{'@'+(val_symbol.to_s)} = vm.pop; "

    vm.context[:cls].create_shared_method(val_name, InstanceVarSpec, [])
  }

  # Add locals specific to a dot colon methods.
  def self.add_dot_colon_locals(context)
    context.create_local_method('var@:', LocalSpec, [:immediate], &DC_VAR)
    context.create_local_method('val@:', LocalSpec, [:immediate], &DC_VAL)
  end


  # DOT COLON COLON =============================

  # [an_object] .:: <name> <stuff omitted> ; []; creates <name> on an_object
  VirtualMachine.create_shared_method('.::', VmSpec, [:immediate],  &lambda {|vm|
    if execute_mode?
      target = vm.pop
      name   = vm.parser.get_word()
      type   = XfOOrth.name_to_type(name)
      XfOOrth.validate_type(vm, type, name)
      XfOOrth.validate_string_method(type, target.class, name)

      begin_compile_mode('.::', obj: target, &lambda {|vm, src, tags|
        vm.dbg_puts "#{target.foorth_name} #{name} => #{src}"
        target.create_exclusive_method(name, type, tags, &eval(src))
      })

      XfOOrth.add_common_compiler_locals(vm, '.::')
      XfOOrth.add_dot_colon_colon_locals(vm.context)
    else
      delayed_compile_mode('.::')
    end
  })

  DCC_VAR = lambda { |vm|
    var_name = vm.parser.get_word()

    unless /^@[a-z][a-z0-9_]*$/ =~ var_name
      error "F10: Invalid var name #{var_name}"
    end

    var_symbol = XfOOrth::SymbolMap.add_entry(var_name)
    vm << "#{'@'+(var_symbol.to_s)} = [vm.pop]; "

    vm.context[:obj].create_exclusive_method(var_name, InstanceVarSpec, [])
  }

  DCC_VAL = lambda {|vm|
    val_name = vm.parser.get_word()

    unless /^@[a-z][a-z0-9_]*$/ =~ val_name
      error "F10: Invalid val name #{val_name}"
    end

    val_symbol = XfOOrth::SymbolMap.add_entry(val_name)
    vm << "#{'@'+(val_symbol.to_s)} = vm.pop; "

    vm.context[:obj].create_exclusive_method(val_name, InstanceVarSpec, [])
  }

  # Add locals specific to a dot colon colon methods.
  def self.add_dot_colon_colon_locals(context)
    context.create_local_method('var@:', LocalSpec, [:immediate], &DCC_VAR)
    context.create_local_method('val@:', LocalSpec, [:immediate], &DCC_VAL)
  end

  # COMMON LOCAL DEFNS ==========================

  #Set up the common local defns.
  #<br>Parameters:
  #* vm - The current virtual machine instance.
  #* ctrl - A list of valid start controls.
  def self.add_common_compiler_locals(vm, ctrl)
    context = vm.context

    #Support for local data.
    context.create_local_method('var:', LocalSpec, [:immediate], &Local_Var_Action)
    context.create_local_method('val:', LocalSpec, [:immediate], &Local_Val_Action)

    #Support for super methods.
    context.create_local_method('super', LocalSpec, [:immediate],
      &lambda {|vm| vm << 'super(vm); ' })

    #The standard end-compile adapter word: ';' semi-colon.
    context.create_local_method(';', LocalSpec, [:immediate],
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

    when /[0-9A-Z$@#]/
      error "F10: Invalid name for a method: #{name}"

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
        error "F90: Spec type mismatch #{spec.foorth_name} vs #{type.foorth_name}"
      end
    else
      Object.create_shared_method(name, type, [:stub]) unless type == VmSpec
    end

  end

  #Check for the case where a string method is created on another class.
  #<br>Parameters
  #*type - The class of the method to be created.
  #*target - The object that is to receive this method.
  #*name - The name of the method to be created.
  #<br>Endemic Code Smells
  #* :reek:ControlParameter -- false positive
  def self.validate_string_method(type, target, name)
    if type == TosSpec && name[-1] == '"' && target != String
      error "F13: Creating a string method #{name} on a #{target.foorth_name}"
    end
  end

end
