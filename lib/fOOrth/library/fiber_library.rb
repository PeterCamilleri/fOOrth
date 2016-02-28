# coding: utf-8

#* library/fiber_library.rb - The fOOrth Fiber/Bundle class library.
module XfOOrth

  fiber = Object.create_foorth_subclass('Fiber').new_class
  bundle = Object.create_foorth_subclass('Bundle').new_class

  #The fOOrth Fiber class.
  class XfOOrth_Fiber

    #Build up the fiber instance. A fiber is a light-weight coroutine.
    def initialize(&block)
      @fiber = Fiber.new &block
    end

    #Let the fiber run for one step
    def step(vm)
      @fiber.resume(vm)
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

  #The .new method is stubbed out fir fibers.
  fiber.create_exclusive_method('.new', TosSpec, [:stub])


end
