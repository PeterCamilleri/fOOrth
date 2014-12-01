# coding: utf-8

#* library/standard_library.rb - The standard fOOrth library.
module XfOOrth

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

  # Stubs for the stack arithmetic words. See numeric_library.rb
  Object.create_shared_method('+',   NosSpec, [:stub])
  Object.create_shared_method('-',   NosSpec, [:stub])
  Object.create_shared_method('*',   NosSpec, [:stub])
  Object.create_shared_method('**',  NosSpec, [:stub])
  Object.create_shared_method('/',   NosSpec, [:stub])
  Object.create_shared_method('mod', NosSpec, [:stub])
  Object.create_shared_method('neg', TosSpec, [:stub])

  # Some bitwise operation words. See numeric_library.rb
  Object.create_shared_method('and', TosSpec, [:stub])
  Object.create_shared_method('or',  TosSpec, [:stub])
  Object.create_shared_method('xor', TosSpec, [:stub])
  Object.create_shared_method('com', TosSpec, [:stub])
  Object.create_shared_method('<<',  NosSpec, [:stub])
  Object.create_shared_method('>>',  NosSpec, [:stub])

end
