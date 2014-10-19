# coding: utf-8

#* standard_library.rb - The standard FORTH library.
module XfOOrth

  # [a] drop []
  @object_class.create_shared_method('drop', MacroWordSpec,
    ["\"vm.pop(); \""])

  # [a] dup [a, a]
  @object_class.create_shared_method('dup', MacroWordSpec,
    ["\"vm.push(vm.peek()); \""])

  # [a] ?dup true: [a,a], false: [a]
  VirtualMachine.create_shared_method('?dup', VmWordSpec, [],
    &lambda {|vm| if peek?() then push(peek()); end; })

  # [b,a] swap [a,b]
  VirtualMachine.create_shared_method('swap', VmWordSpec, [],
    &lambda {|vm| b,a = popm(2); push(a); push(b); })

  # [c,b,a] rot [b,a,c]
  VirtualMachine.create_shared_method('rot', VmWordSpec, [],
    &lambda {|vm| c,b,a = popm(3); push(b); push(a); push(c); })

  # [b,a] over [b,a,b]
  @object_class.create_shared_method('over', MacroWordSpec,
    ["\"vm.push(vm.peek(2)); \""])

  # [di,..d2,d1,i] pick [di,..d2,d1,di]
  @object_class.create_shared_method('pick', MacroWordSpec,
    ["\"vm.push(vm.peek(vm.pop))\""])

  # [b,a] nip [a]
  VirtualMachine.create_shared_method('nip', VmWordSpec, [],
    &lambda {|vm| b,a = popm(2); push(a); })

  # [b,a] tuck [a,b,a]
  VirtualMachine.create_shared_method('tuck', VmWordSpec, [],
    &lambda {|vm| b,a = popm(2); push(a); push(b); push(a); })

end
