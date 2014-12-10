# coding: utf-8

#* library/thread_library.rb - The thread support fOOrth library.
module XfOOrth

  #Connect the Thread class to the fOOrth class system.
  Thread.create_foorth_proxy

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


  #Other methods
  VirtualMachine.create_shared_method('pause', MacroSpec,
    [:macro, 'Thread.pass; '])

  Numeric.create_shared_method('.sleep', TosSpec, [], &lambda {|vm|
    sleep(self)
  })
end

#* Runtime library support for fOOrth constructs.
class Thread

  # Runtime support for the .new{ } construct.
  def self.do_foorth_new_block(vm, &block)
    Thread.new(vm.foorth_copy('-')) { |vm|
      block.call(vm.install_thread, nil)
    }
  end

end
