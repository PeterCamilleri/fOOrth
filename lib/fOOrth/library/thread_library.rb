# coding: utf-8

#* library/thread_library.rb - The thread support fOOrth library.
module XfOOrth

  #Connect the Thread class to the fOOrth class system.
  Thread.create_foorth_proxy

  # [] Thread .new{ ... } [a_thread]
  #Uses the default implementation of .new{ ... }

  #Class Methods
  # [Thread] .current [the current thread]
  Thread.create_exclusive_method('.current', TosSpec, [], &lambda {|vm|
    vm.push(Thread.current)
  })

  # [Thread] .main [the main thread]
  Thread.create_exclusive_method('.main', TosSpec, [], &lambda {|vm|
    vm.push(Thread.main)
  })

  # [Thread] .list [[threads]]
  Thread.create_exclusive_method('.list', TosSpec, [], &lambda {|vm|
    vm.push(Thread.list)
  })

  #Instance Methods
  # [a thread] .vm [the vm of the thread or nil]
  Thread.create_shared_method('.vm', TosSpec, [], &lambda {|vm|
    vm.push(self[:vm])
  })

  #Pause the current thread.
  VirtualMachine.create_shared_method('pause', MacroSpec,
    [:macro, 'Thread.pass; '])

  #Put the current thread to sleep for the specified number of seconds.
  Numeric.create_shared_method('.sleep', TosSpec, [], &lambda {|vm|
    sleep(Float.foorth_coerce(self))
  })

  #Wait for a thread to finish.
  #[a_thread] .join []
  Thread.create_shared_method('.join', TosSpec, [], &lambda {|vm|
    self.join
  })

  #Is the thread sill alive?
  #[a_thread] .alive? [a_boolean]
  Thread.create_shared_method('.alive?', TosSpec, [], &lambda {|vm|
    vm.push(self.alive?)
  })

  #What is the status of this thread?
  #[a_thread] .status ["a_status_string"]
  Thread.create_shared_method('.status', TosSpec, [], &lambda {|vm|
    vm.push(self.status || 'dead')
  })

  #Terminate the given thread.
  Thread.create_shared_method('.exit', TosSpec, [], &lambda {|vm|
    self.exit
  })

end

#* Runtime library support for fOOrth constructs.
class Thread

  # Runtime support for the .new{ } construct.
  #<br>Parameters
  #* vm - The parent VirtualMachine instance.
  #* block = The block of code to be executed in the new thread.
  #<br>Returns
  #* The newly created Thread instance.
  #<br>Endemic code smells
  #* :reek:TooManyStatements
  def self.do_foorth_new_block(vm, &block)
    interlock = Queue.new

    result = Thread.new(vm.foorth_copy(vm.pop.to_s)) do |vm|
      vm.connect_vm_to_thread
      self.foorth_init(vm)
      interlock.push(:ready)
      vm.instance_exec(vm, nil, &block)
    end

    interlock.pop
    result
  end

end
