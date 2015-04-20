# coding: utf-8

#* library/class_library.rb - The fOOrth Class class library.
module XfOOrth

  #Create a macro to get at the current virtual machine instance.
  # [] vm [the_current_vm]
  VirtualMachine.create_shared_method('vm', MacroSpec,
    [:macro, "vm.push(vm); "])

  # [vm] .vm_name ['name']
  VirtualMachine.create_shared_method('.vm_name', TosSpec, [],
    &lambda {|vm| vm.push(self.name); })

  # [vm] .dump []
  VirtualMachine.create_shared_method('.dump', TosSpec, [],
    &lambda {|vm| self.debug_dump; })

  # Some stack manipulation words.
  # [a] drop []
  VirtualMachine.create_shared_method('drop', MacroSpec,
    [:macro, "vm.pop(); "])

  # Some stack manipulation words.
  # [unspecified] clear [];
  VirtualMachine.create_shared_method('clear', VmSpec, [], &lambda {|vm|
    vm.data_stack.clear
  })

  # [a] dup [a, a]
  VirtualMachine.create_shared_method('dup', MacroSpec,
    [:macro, "vm.push(vm.peek()); "])

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

  #Get the VM timer start time.
  #[] .start [start_time]
  VirtualMachine.create_shared_method('.start', TosSpec, [], &lambda {|vm|
    vm.push(vm.start_time)
  })

  #Reset the VM timer start time.
  #[] .restart []
  VirtualMachine.create_shared_method('.restart', TosSpec, [], &lambda {|vm|
    vm.start_time = Time.now
  })

  #Get the elapsed time.
  #[] .elapsed [elapsed_time_in_seconds]
  VirtualMachine.create_shared_method('.elapsed', TosSpec, [], &lambda {|vm|
    vm.push(Time.now - vm.start_time)
  })

end
