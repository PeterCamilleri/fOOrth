# coding: utf-8

#* library/class_library.rb - The fOOrth Class class library.
module XfOOrth

  #Create a macro to get at the current virtual machine instance.
  # [] vm [the_current_vm]
  VirtualMachine.create_shared_method('vm', MacroSpec,
    [:macro, "vm.push(vm); "])

  # Some stack manipulation words.
  # [a] drop []
  VirtualMachine.create_shared_method('drop', MacroSpec,
    [:macro, "vm.pop(); "])

  # [a] dup [a, a]
  VirtualMachine.create_shared_method('dup', MacroSpec,
    [:macro, "vm.push(vm.peek()); "])

  # [a] clone [a, a']
  VirtualMachine.create_shared_method('clone', MacroSpec,
    [:macro, "vm.push(vm.peek.full_clone); "])

  # [a] .clone [a']
  Object.create_shared_method('.clone', TosSpec, [],
    &lambda {|vm| vm.push(self.full_clone); })

  # [a] ?dup if a is true then [a,a] else [a]
  VirtualMachine.create_shared_method('?dup', VmSpec, [],
    &lambda {|vm| if peek?() then push(peek()); end; })

  # [b,a] swap [a,b]
  VirtualMachine.create_shared_method('swap', VmSpec, [],
    &lambda {|vm| vb,va = popm(2); push(va); push(vb); })

  # [c,b,a] rot [b,a,c]
  VirtualMachine.create_shared_method('rot', VmSpec, [],
    &lambda {|vm| vc,vb,va = popm(3); push(vb); push(va); push(vc); })

  # [b,a] over [b,a,b]
  VirtualMachine.create_shared_method('over', MacroSpec,
    [:macro, "vm.push(vm.peek(2)); "])

  # [di,..d2,d1,i] pick [di,..d2,d1,di]
  VirtualMachine.create_shared_method('pick', MacroSpec,
    [:macro, "vm.push(vm.peek(vm.pop())); "])

  # [b,a] nip [a]
  VirtualMachine.create_shared_method('nip', MacroSpec,
    [:macro, "vm.swap_pop(); "])

  # [b,a] tuck [a,b,a]
  VirtualMachine.create_shared_method('tuck', VmSpec, [],
    &lambda {|vm| vb,va = popm(2); push(va); push(vb); push(va); })

end
