# coding: utf-8

#* library/alias_library.rb - Support for method aliasing in fOOrth.
module XfOOrth

  VirtualMachine.create_shared_method('.alias:', VmSpec, [:immediate],  &lambda {|vm|
    new_name = vm.parser.get_word()
    vm.process_text("vm.create_shared_alias(#{new_name.inspect}); ")
  })

  VirtualMachine.create_shared_method('.alias::', VmSpec, [:immediate],  &lambda {|vm|
    new_name = vm.parser.get_word()
    vm.process_text("vm.create_exclusive_alias(#{new_name.inspect}); ")
  })

  # Alias support methods in the VirtualMachine class.
  class VirtualMachine
    ALLOWED_ALIAS_TYPES = {
      TosSpec  => [TosSpec, SelfSpec],
      SelfSpec => [TosSpec, SelfSpec],
      NosSpec  => [NosSpec]
    }

    #Create a shared method alias
    def create_shared_alias(new_name)
      old_name, target = popm(2)
      error "F13: The target of .alias: must be a class" unless target.is_a?(Class)

      old_symbol = XfOOrth::SymbolMap.map(old_name)
      error "F10: ?#{old_name}?" unless old_symbol
      old_spec = target.map_foorth_shared(old_symbol)
      f20_error(target, old_name, old_symbol) unless old_spec

      target.create_shared_method(new_name,
                                  get_alias_type(old_spec, new_name),
                                  [],
                                  &old_spec.does)
    end

    #Create an exclusive method alias
    def create_exclusive_alias(new_name)
      old_name, target = popm(2)

      old_symbol = XfOOrth::SymbolMap.map(old_name)
      error "F10: ?#{old_name}?" unless old_symbol
      old_spec = target.map_foorth_exclusive(old_symbol)
      f20_error(target, old_name, old_symbol) unless old_spec

      target.create_exclusive_method(new_name,
                                     get_alias_type(old_spec, new_name),
                                     [],
                                     &old_spec.does)
    end

    private

    #Get the type of the aliased method.
    def get_alias_type(old_spec, new_name)
      old_type = old_spec.class
      new_type = XfOOrth.name_to_type(new_name, get_cast)
      old_spec_name = old_type.foorth_name
      new_spec_name = new_type.foorth_name

      unless (allowed = ALLOWED_ALIAS_TYPES[old_type])
        error "F13: A #{old_spec_name} method may not be aliased."
      end

      unless allowed.include?(new_type)
        error "F13: A #{old_spec_name} method may not be aliased as a #{new_spec_name}"
      end

      new_type
    end

  end

end
