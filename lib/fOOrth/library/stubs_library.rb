# coding: utf-8

#* library/stubs_library.rb - Support for method stubs in fOOrth.
module XfOOrth
  VirtualMachine.create_shared_method('stub:', VmSpec, [:immediate],
  &lambda {|vm|
    name = parser.get_word().inspect
    process_text("vm.class.create_shared_method(#{name}, VmSpec, [:stub]); ")
  })

  VirtualMachine.create_shared_method('.stub:', VmSpec, [:immediate],
  &lambda {|vm|
    name = parser.get_word().inspect
    process_text("vm.create_shared_stub(#{name}); ")
  })

  VirtualMachine.create_shared_method('.stub::', VmSpec, [:immediate],
  &lambda {|vm|
    name = parser.get_word().inspect
    process_text("vm.create_exclusive_stub(#{name}); ")
  })

  # Stub support methods in the VirtualMachine class.
  class VirtualMachine

    #Create a shared method stub
    def create_shared_stub(name)
      unless (target = pop).is_a?(Class)
        error "F13: The target of .stub: must be a class"
      end

      type = XfOOrth.name_to_type(name, self)
      XfOOrth.validate_type(self, type, name)
      target.create_shared_method(name, type, [:stub])
      clear_cast
    end

    #Create an exclusive method stub
    def create_exclusive_stub(name)
      target = pop
      type = XfOOrth.name_to_type(name, self)
      XfOOrth.validate_type(self, type, name)
      target.create_exclusive_method(name, type, [:stub])
      clear_cast
    end

  end

end
