# coding: utf-8

#* library/thread_library.rb - The thread support fOOrth library.
module XfOOrth

  #Connect the Thread class to the fOOrth class system.
  Thread.create_foorth_proxy

  #Class Methods

  Thread.create_exclusive_method('.new', TosSpec, [:stub])

  # [name Thread]  .new{{ ... }} [a_thread]
  Thread.create_exclusive_method('.new{{', NosSpec, [], &lambda {|vm|
    block = vm.pop
    name  = vm.pop.to_s
    vm.push(block.do_thread_start(vm, name))
  })

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
