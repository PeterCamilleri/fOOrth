# coding: utf-8

#* library/procedure_library.rb - Proc support for the fOOrth library.
module XfOOrth

  #Connect the Proc class to the fOOrth class system.
  Proc.create_foorth_proxy('Procedure')

  # A no operation place holder for procedure literals
  VirtualMachine.create_shared_method('{{', MacroSpec, [:macro, " "])

  # [procedure] .call [unspecified]
  Proc.create_shared_method('.call', TosSpec, [],
    &lambda {|vm| self.call(vm); })

  # [owner procedure] .call_with [unspecified]
  Proc.create_shared_method('.call_with', TosSpec, [],
    &lambda {|vm| vm.pop.instance_exec(vm, &self); })

  # [v procedure] .call_v [unspecified]
  Proc.create_shared_method('.call_v', TosSpec, [],
    &lambda {|vm| value = vm.pop; self.call(vm, value); })

  # [x procedure] .call_x [unspecified]
  Proc.create_shared_method('.call_x', TosSpec, [],
    &lambda {|vm| index = vm.pop; self.call(vm, nil, index); })

  # [v x procedure] .call_vx [unspecified]
  Proc.create_shared_method('.call_vx', TosSpec, [],
    &lambda {|vm| value, index = vm.popm(2); self.call(vm, value, index); })

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

    result = Thread.new(vm.foorth_copy(vm_name)) do |vm_copy|
      begin
        self.foorth_init(vm_copy.compiler_reset.connect_vm_to_thread)
      ensure
        interlock.push(:ready)
      end

      vm_copy.instance_exec(vm_copy, &block)
    end

    interlock.pop
    result
  end
end

