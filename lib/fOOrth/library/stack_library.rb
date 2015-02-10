# coding: utf-8

require 'thread'

#* library/queue_library.rb - The Queue support fOOrth library.
module XfOOrth

  #Connect the Queue class to the fOOrth class system.
  stack = Object.create_foorth_subclass('Stack').new_class

  #Uses the default implementation of the .new method.

  #Initialize the Stack object.
  stack.create_shared_method('.init', TosSpec, [], &lambda {|vm|
    @data = []
  })

  #[v stack] .push []; pushes the v onto the stack.
  stack.create_shared_method('.push', TosSpec, [], &lambda {|vm|
    @data << vm.pop
  })

  #[stack] .pop [v]; pops the v from the stack.
  stack.create_shared_method('.pop', TosSpec, [], &lambda {|vm|
    if @data.length > 0
      vm.push(@data.pop)
    else
      error "F31: Stack Underflow: .pop"
    end
  })

  #[stack] .peek [v]; sneaks a peek at the top item of the stack.
  stack.create_shared_method('.peek', TosSpec, [], &lambda {|vm|
    if @data.length > 0
      vm.push(@data[-1])
    else
      error "F31: Stack Underflow: .peek"
    end
  })

  #[stack] .empty? [a_boolean]
  stack.create_shared_method('.empty?', TosSpec, [], &lambda {|vm|
    vm.push(@data.empty?)
  })

  #[stack] .length [an_integer]
  stack.create_shared_method('.length', TosSpec, [], &lambda {|vm|
    vm.push(@data.length)
  })

end
