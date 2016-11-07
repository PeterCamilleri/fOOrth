# coding: utf-8

require 'thread'

#* library/queue_library.rb - The Queue support fOOrth library.
module XfOOrth

  #Connect the Queue class to the fOOrth class system.
  Queue.create_foorth_proxy("Queue")

  #Uses the default implementation of the .new method.

  # [v queue] .push []; v is pushed onto the queue
  Queue.create_shared_method('.push', TosSpec, [], &lambda {|vm|
    self.push(vm.pop)
  })

  # [queue] .pop [v]; v is popped from the queue
  Queue.create_shared_method('.pop', TosSpec, [], &lambda {|vm|
    if self.length > 0
      vm.push(self.pop)
    else
      error "F31: Queue Underflow: .pop"
    end
  })

  # [queue] .pend [v]; v is popped from the queue, will pend for data.
  Queue.create_shared_method('.pend', TosSpec, [], &lambda {|vm|
    vm.push(self.pop)
  })

  # [queue] .empty? [a_boolean]
  Queue.create_shared_method('.empty?', TosSpec, [], &lambda {|vm|
    vm.push(self.empty?)
  })

  # [queue] .present? [a_boolean]
  Queue.create_shared_method('.present?', TosSpec, [], &lambda {|vm|
    vm.push(!self.empty?)
  })

  # [queue] .length [an_integer]
  Queue.create_shared_method('.length', TosSpec, [], &lambda {|vm|
    vm.push(self.length)
  })

  # [queue] .clear []
  Queue.create_shared_method('.clear!', TosSpec, [], &lambda {|vm|
    self.clear
  })

end
