# coding: utf-8

#* library/procedure_library.rb - Proc support for the fOOrth library.
module XfOOrth

  #Connect the Proc class to the fOOrth class system.
  Proc.create_foorth_proxy('Procedure')

  #Lambda literals in fOOrth.
  VirtualMachine.create_shared_method('{{', VmSpec, [:immediate],
    &lambda {|vm|
      suspend_execute_mode('vm.push(lambda {|vm| ', :lambda)

      context.create_local_method('}}', [:immediate],
        &lambda {|vm| resume_execute_mode('}); ', [:lambda]) })
    })

  # [procedure] .call [unspecified]
  Proc.create_shared_method('.call', TosSpec, [],
    &lambda {|vm| self.call(vm); })

  # [procedure] .start [a_thread]
  Proc.create_shared_method('.start', TosSpec, [], &lambda {|vm|
    block = self
    interlock = Queue.new

    vm.push(Thread.new(vm.foorth_copy('-')) {|vm|
      vm.compiler_reset
      vm.connect_vm_to_thread
      self.foorth_init(vm)
      interlock.push(:ready)
      vm.instance_exec(vm, &block)
    })

    interlock.pop
  })

  # [procedure] .start_named [a_thread]
  Proc.create_shared_method('.start_named', TosSpec, [], &lambda {|vm|
    block = self
    thread_name = vm.pop.to_s
    interlock = Queue.new

    vm.push(Thread.new(vm.foorth_copy(thread_name)) {|vm|
      vm.compiler_reset
      vm.connect_vm_to_thread
      self.foorth_init(vm)
      interlock.push(:ready)
      vm.instance_exec(vm, &block)
    })

    interlock.pop
  })


end
