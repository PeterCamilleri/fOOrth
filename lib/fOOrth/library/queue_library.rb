# coding: utf-8

require 'thread'

#* library/queue_library.rb - The Queue support fOOrth library.
module XfOOrth

  #Connect the Queue class to the fOOrth class system.
  Queue.create_foorth_proxy

  #Uses the default implementation of the .new method.

  # [v queue] .push []; v is pushed onto the queue
  Queue.create_shared_method('.push', TosSpec, [], &lambda {|vm|
    self.push(vm.pop)
  })

  # [queue] .pop [v]; v is popped from the queue
  Queue.create_shared_method('.pop', TosSpec, [], &lambda {|vm|
    vm.push(self.pop)
  })


end
