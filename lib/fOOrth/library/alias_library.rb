# coding: utf-8

#* library/alias_library.rb - Support for method aliasing in fOOrth.
module XfOOrth

  VirtualMachine.create_shared_method('.alias:', VmSpec, [:immediate],  &lambda {|vm|
    new_name = vm.parser.get_word()
    vm.process_text("vm.create_shared_alias(#{new_name.inspect}); ")
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
      error "F20: The class #{target.foorth_name} does not understand #{old_name}" unless old_spec

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

      target.create_shared_method(new_name, new_type, [], &old_spec.does)
    end

  end

end
