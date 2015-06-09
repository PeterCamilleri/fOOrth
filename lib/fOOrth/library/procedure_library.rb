# coding: utf-8

#* library/procedure_library.rb - Proc support for the fOOrth library.
module XfOOrth

  #Connect the Proc class to the fOOrth class system.
  Proc.create_foorth_proxy('Procedure')

  #Lambda literals in fOOrth.
  VirtualMachine.create_shared_method('{{', VmSpec, [:immediate],
    &lambda {|vm|
      suspend_execute_mode('vm.push(lambda {|vm| ', :lambda)

      context.create_local_method('}}', LocalSpec, [:immediate],
        &lambda {|vm| resume_execute_mode('}); ', [:lambda]) })
    })

  # [procedure] .call [unspecified]
  Proc.create_shared_method('.call', TosSpec, [],
    &lambda {|vm| self.call(vm); })

  # [owner procedure] .call_with [unspecified]
  Proc.create_shared_method('.call_with', TosSpec, [],
    &lambda {|vm| vm.pop.instance_exec(vm, &self); })

  # [procedure] .start [a_thread]
  Proc.create_shared_method('.start', TosSpec, [], &lambda {|vm|
    vm.push(self.do_thread_start(vm, '-'))
  })

  # [procedure] .start_named [a_thread]
  Proc.create_shared_method('.start_named', TosSpec, [], &lambda {|vm|
    vm.push(self.do_thread_start(vm, vm.pop.to_s))
  })

end

#A helper method in the Proc class for fOOrth threads.
class Proc
  #Do the mechanics of starting a thread.
  def do_thread_start(vm, vm_name)
    block, interlock = self, Queue.new

    result = Thread.new(vm.foorth_copy(vm_name)) { |vm_copy|
      self.foorth_init(vm_copy.compiler_reset.connect_vm_to_thread)
      interlock.push(:ready)
      vm_copy.instance_exec(vm_copy, &block)
    }

    interlock.pop
    result
  end
end

