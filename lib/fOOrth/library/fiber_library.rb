# coding: utf-8

#* library/fiber_library.rb - The fOOrth Fiber class library.
module XfOOrth

  #Define the Fiber class.
  Object.create_foorth_subclass('Fiber').new_class

  #The fOOrth Fiber class.
  class XfOOrth_Fiber

    #Tag for newly created fibers.
    NEW   = "new".freeze

    #Tag for running fibers.
    ALIVE = "alive".freeze

    #Tag for defunct fibers.
    DEAD  = "dead".freeze

    #Build up the fiber instance. A fiber is a light-weight coroutine.
    def initialize(stack=[], &block)
      @stack = stack
      @fiber = Fiber.new &lambda{|vm| block.call(vm); nil}
      @status = NEW
    end

    #Return this fiber as a fiber.
    def to_fiber
      self
    end

    #What is the status of this fiber?
    def status
      @status || DEAD
    end

    #Let the fiber run for one step.
    def step(vm)
      vm.data_stack, vm.fiber, @save = @stack, self, vm.data_stack
      @status = @fiber.resume(vm)
    rescue FiberError
      error "F72: Cannot step a dead fiber."
    ensure
      vm.data_stack, vm.fiber, @stack = @save, nil, vm.data_stack
    end

    #Yield back to the thread.
    def yield
      Fiber.yield(ALIVE)
    end

    #Yield a value back to the thread.
    def yield_value(value)
      @save << value
      Fiber.yield(ALIVE)
    end
  end

  #The .new method is stubbed out for fibers.
  XfOOrth_Fiber.create_exclusive_method('.new', TosSpec, [:stub])

  # [Fiber] .new{{ ... }} [a_fiber]
  XfOOrth_Fiber.create_exclusive_method('.new{{', NosSpec, [], &lambda {|vm|
    vm.push(XfOOrth_Fiber.new(&vm.pop))
  })

  # [a_procedure] .to_fiber [a_fiber]
  Proc.create_shared_method('.to_fiber', TosSpec, [], &lambda {|vm|
    vm.push(XfOOrth_Fiber.new(&self))
  })

  # [Fiber] .current [a_fiber or nil]
  XfOOrth_Fiber.create_exclusive_method('.current', NosSpec, [], &lambda {|vm|
    vm.push(vm.fiber)
  })

  # [a_fiber] .to_fiber [a_fiber]
  XfOOrth_Fiber.create_shared_method('.to_fiber', TosSpec, [], &lambda {|vm|
    vm.push(self)
  })

  # [a_fiber] .step [undefined]; The fiber performs a processing step.
  XfOOrth_Fiber.create_shared_method('.step', TosSpec, [], &lambda {|vm|
    self.step(vm)
  })

  # [] yield []; Yields obj to the containing thread.
  VirtualMachine.create_shared_method('yield', VmSpec, [], &lambda {|vm|
    error 'F71: May only yield in a fiber.' unless (fiber = vm.fiber)
    fiber.yield
  })

  # [obj] .yield []; Yields obj to the containing thread.
  VirtualMachine.create_shared_method('.yield', VmSpec, [], &lambda {|vm|
    error 'F71: May only yield in a fiber.' unless (fiber = vm.fiber)
    fiber.yield_value(vm.pop)
  })

  # [a_fiber] .alive? [a_boolean]; Is the fiber still alive?
  XfOOrth_Fiber.create_shared_method('.alive?', TosSpec, [], &lambda {|vm|
    vm.push(!@status.nil?)
  })

end

#Monkey patch Procedure to support fibers.
class Proc

  #Convert this procedure to a fiber.
  def to_fiber
    XfOOrth::XfOOrth_Fiber.new(&self)
  end

end
