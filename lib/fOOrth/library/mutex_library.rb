# coding: utf-8

#* library/mutex_library.rb - The mutex support fOOrth library.
module XfOOrth

  #Connect the Mutex class to the fOOrth class system
  Mutex.create_foorth_proxy

  # [a_mutex] .lock [] (Acquires a lock on the mutex)
  Mutex.create_shared_method('.lock', TosSpec, [], &lambda {|vm|
    self.lock
  })

  # [a_mutex] .unlock [] (Releases a lock on the mutex)
  Mutex.create_shared_method('.unlock', TosSpec, [], &lambda {|vm|
    self.unlock
  })

  # [a_mutex] .do{{ ... }} [] (Releases a lock on the mutex)
  Mutex.create_shared_method('.do{{', NosSpec, [], &lambda {|vm|
    block = vm.pop
    self.synchronize { block.call(vm, nil, nil) }
  })

end
