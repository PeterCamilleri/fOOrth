# coding: utf-8

#* library/fiber_library.rb - The fOOrth Fiber/Bundle class library.
module XfOOrth

  fiber = Object.create_foorth_subclass('Fiber').new_class
  bundle = Object.create_foorth_subclass('Bundle').new_class

  #The fOOrth Fiber class.
  class XfOOrth_Fiber

    NEW   = "new".freeze
    ALIVE = "alive".freeze
    DEAD  = "dead".freeze

    #Build up the fiber instance. A fiber is a light-weight coroutine.
    def initialize(stack=[], &block)
      @stack = stack
      @fiber = Fiber.new &lambda{|vm| block.call(vm); nil}
      @status = NEW
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

  #The fOOrth Bundle class. A bundle contains multiple fibers.
  class XfOOrth_Bundle

    #Build up the fiber instance
    def initialize(fibers=[])
      @fibers = fibers
      @current = 0
    end

    #Let the fiber run for one step
    def step(vm)
      if @current < @fibers.length
        unless @fibers[@current].step(vm)
          @current += 1
        else
          @fibers.delete_at(@current)
        end
      end

      @current = 0 unless @current < @fibers.length
    end

    #Run the fiber bundle constantly until done.
    def run(vm)
      until @fibers.empty?
        step(vm)
      end
    end
  end

  #The .new method is stubbed out for fibers.
  fiber.create_exclusive_method('.new', TosSpec, [:stub])

  # [Fiber] .new{{ ... }} [a_fiber]
  XfOOrth_Fiber.create_exclusive_method('.new{{', NosSpec, [], &lambda {|vm|
    vm.push(XfOOrth_Fiber.new(&vm.pop))
  })

  # [a_procedure] .to_fiber [a_fiber]
  Proc.create_shared_method('.to_fiber', TosSpec, [], &lambda {|vm|
    vm.push(XfOOrth_Fiber.new(&self))
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
