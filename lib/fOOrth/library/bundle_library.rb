# coding: utf-8

#* library/bundle_library.rb - The fOOrth Bundle class library.
module XfOOrth

  #Define the Bundle class.
  Object.create_foorth_subclass('Bundle').new_class

  #The fOOrth Bundle class. A bundle contains multiple fibers.
  class XfOOrth_Bundle

    #Build up the fiber instance
    def initialize(fibers=[])
      @fibers = fibers.in_array.map {|f| f.to_fiber}
      @current = 0
    rescue NoMethodError
      error "F70: A bundle may only contain procedures, fibers, or bundles."
    end

    #Add the fibers to this bundle.
    def add_fibers(fibers)
      fibers.in_array.each {|f| @fibers << f.to_fiber}
    rescue NoMethodError
      error "F70: A bundle may only contain procedures, fibers, or bundles."
    end

    #Return this bundle as a fiber.
    def to_fiber
      self
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

  # [a_bundle] .to_fiber [a_bundle] ; Bundles are compatible with fibers.
  XfOOrth_Bundle.create_shared_method('.to_fiber', TosSpec, [], &lambda {|vm|
    vm.push(self)
  })

  #[an_array_of_procs_fibers_or_bundles] .to_bundle [a_bundle]
  Array.create_shared_method('.to_bundle', TosSpec, [], &lambda{|vm|
    vm.push(XfOOrth_Bundle.new(self))
  })

  #[a_proc] .to_bundle [a_bundle]
  Proc.create_shared_method('.to_bundle', TosSpec, [], &lambda{|vm|
    vm.push(XfOOrth_Bundle.new(self))
  })

  # [a_proc_fiber_or_bundle a_bundle] .add [] ; Add to the bundle.
  XfOOrth_Bundle.create_shared_method('.add', TosSpec, [], &lambda {|vm|
    self.add_fibers(vm.pop)
  })

  #[a_bundle] .step []; Do a single step on the bundle.
  XfOOrth_Bundle.create_shared_method('.step', TosSpec, [], &lambda{|vm|
    step(vm)
  })

  #[a_bundle] .run []; Run the bundle until all of its fibers are done.
  XfOOrth_Bundle.create_shared_method('.run', TosSpec, [], &lambda{|vm|
    run(vm)
  })

  # [a_bundle] .alive? [a_boolean]; Does the bundle still have fibers in it?
  XfOOrth_Bundle.create_shared_method('.alive?', TosSpec, [], &lambda {|vm|
    vm.push(!@fibers.empty?)
  })

  # [a_bundle] .length [a_count]; How many fibers does the bundle have?
  XfOOrth_Bundle.create_shared_method('.length', TosSpec, [], &lambda {|vm|
    vm.push(@fibers.length)
  })

end
