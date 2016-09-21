# coding: utf-8

#* library/alias_library.rb - Support for method aliasing in fOOrth.
module XfOOrth

  VirtualMachine.create_shared_method('alias:', VmSpec, [:immediate],
  &lambda {|vm|
    new_name = parser.get_word().inspect
    process_text("vm.create_word_alias(#{new_name}); ")
  })

  VirtualMachine.create_shared_method('.alias:', VmSpec, [:immediate],
  &lambda {|vm|
    new_name = parser.get_word().inspect
    process_text("vm.create_shared_alias(#{new_name}); ")
  })

  VirtualMachine.create_shared_method('.alias::', VmSpec, [:immediate],
  &lambda {|vm|
    new_name = parser.get_word().inspect
    process_text("vm.create_exclusive_alias(#{new_name}); ")
  })

  # Alias support methods in the VirtualMachine class.
  class VirtualMachine
    ALLOWED_ALIAS_TYPES = {
      TosSpec  => [TosSpec, SelfSpec],
      SelfSpec => [TosSpec, SelfSpec],
      NosSpec  => [NosSpec]
    }

    #Create a virtual machine word method alias.
    def create_word_alias(new_name)
      old_name, target = pop, self.class

      old_spec = get_old_shared_spec(target, old_name)

      target.create_shared_method(new_name,
                                  old_spec.class,
                                  old_spec.tags,
                                  &old_spec.does)
    end

    #Create a shared method alias
    def create_shared_alias(new_name)
      old_name, target = popm(2)

      unless target.is_a?(Class)
        error "F13: The target of .alias: must be a class"
      end

      old_spec = get_old_shared_spec(target, old_name)

      target.create_shared_method(new_name,
                                  get_alias_type(old_spec, new_name),
                                  old_spec.tags,
                                  &old_spec.does)
      clear_cast
    end

    #Create an exclusive method alias
    def create_exclusive_alias(new_name)
      old_name, target = popm(2)

      old_spec = get_old_exclusive_spec(target, old_name)

      target.create_exclusive_method(new_name,
                                     get_alias_type(old_spec, new_name),
                                     old_spec.tags,
                                     &old_spec.does)
      clear_cast
    end

    private

    #Get the shared specification of the original method.
    def get_old_shared_spec(target, old_name)
      old_symbol = get_old_symbol(old_name)

      unless (old_spec = target.map_foorth_shared(old_symbol))
        f20_error(target, old_name, old_symbol)
      end

      old_spec
    end

    #Get the exclusive specification of the original method.
    def get_old_exclusive_spec(target, old_name)
      old_symbol = get_old_symbol(old_name)

      unless (old_spec = target.map_foorth_exclusive(old_symbol))
        f20_error(target, old_name, old_symbol)
      end

      old_spec
    end

    #Get the symbol of the old method.
    def get_old_symbol(old_name)
      old_symbol = XfOOrth::SymbolMap.map(old_name)
      error "F10: ?#{old_name}?" unless old_symbol
      old_symbol
    end

    #Get the type of the aliased method.
    def get_alias_type(old_spec, new_name)
      old_type = old_spec.class
      new_type = XfOOrth.name_to_type(new_name, self)
      old_desc, new_desc = old_type.foorth_name, new_type.foorth_name

      unless (allowed = ALLOWED_ALIAS_TYPES[old_type])
        error "F13: A #{old_desc} method may not be aliased."
      end

      unless allowed.include?(new_type)
        error "F13: A #{old_desc} method may not be aliased as a #{new_desc}"
      end

      XfOOrth.validate_type(self, new_type, new_name)

      new_type
    end

  end

end
