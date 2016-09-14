# coding: utf-8

#* library/class_library.rb - The fOOrth Class class library.
module XfOOrth

  #Get the VM as a string.
  # [vm] .to_s ["vm as a string"]
  VirtualMachine.create_shared_method('.to_s', TosSpec, [],
    &lambda {|vm| vm.push(self.foorth_name.freeze)})

  #Create a macro to get at the current virtual machine instance.
  # [] vm [the_current_vm]
  VirtualMachine.create_shared_method('vm', MacroSpec,
    [:macro, "vm.push(vm); "])

  # [vm] .vm_name ['name']
  VirtualMachine.create_shared_method('.vm_name', TosSpec, [],
    &lambda {|vm| vm.push(self.name) })

  # Some stack manipulation words.
  # [a] drop []
  VirtualMachine.create_shared_method('drop', MacroSpec,
    [:macro, "vm.pop(); "])

  # [a, b] 2drop []
  VirtualMachine.create_shared_method('2drop', MacroSpec,
    [:macro, "vm.popm(2); "])

  # Some stack manipulation words.
  # [unspecified] clear [];
  VirtualMachine.create_shared_method('clear', VmSpec, [], &lambda {|vm|
    vm.data_stack.clear
  })

  # [a] dup [a, a]
  VirtualMachine.create_shared_method('dup', MacroSpec,
    [:macro, "vm.push(vm.peek()); "])

  # [a, b] 2dup [a, b, a, b]
  VirtualMachine.create_shared_method('2dup', MacroSpec,
    [:macro, "vm.push(vm.peek(2)); vm.push(vm.peek(2));"])

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
    [:macro, "vm.push(vm.peek(Integer.foorth_coerce(vm.pop()))); "])

  # [b,a] nip [a]
  VirtualMachine.create_shared_method('nip', MacroSpec,
    [:macro, "vm.swap_pop(); "])

  # [b,a] tuck [a,b,a]
  VirtualMachine.create_shared_method('tuck', VmSpec, [],
    &lambda {|vm| vb,va = popm(2); push(va); push(vb); push(va); })

  #Get the VM timer start time.
  #[] .start [start_time]
  VirtualMachine.create_shared_method('.start_time', TosSpec, [], &lambda {|vm|
    vm.push(vm.start_time)
  })

  #Reset the VM timer start time.
  #[] .restart []
  VirtualMachine.create_shared_method('.restart_timer', TosSpec, [], &lambda {|vm|
    vm.start_time = Time.now
  })

  #Get the elapsed time.
  #[] .elapsed [elapsed_time_in_seconds]
  VirtualMachine.create_shared_method('.elapsed_time', TosSpec, [], &lambda {|vm|
    vm.push(Time.now - vm.start_time)
  })

  #Get the name of the code source.
  #[] _FILE_ [a_string]
  VirtualMachine.create_shared_method('_FILE_', VmSpec, [:immediate], &lambda{|vm|
    file_name = @parser.source.file_name

    if execute_mode?
      vm.push(file_name)
    else
      vm << "vm.push(#{file_name.inspect})"
    end
  })

end
