# coding: utf-8

#* library/bundle_library.rb - The fOOrth Bundle class library.
module XfOOrth

  #Define the Bundle class.
  Object.create_foorth_subclass('Bundle').new_class

  #The fOOrth Bundle class. A bundle contains multiple fibers.
  class XfOOrth_Bundle

    #Build up the bundle instance
    def initialize(fibers=[])
      @fibers = fibers.in_array.map {|f| f.to_foorth_fiber}
      @current = 0
    rescue NoMethodError
      error "F70: A bundle may only contain procedures, fibers, or bundles."
    end

    #Add the fibers to this bundle.
    def add_fibers(fibers)
      fibers.in_array.each {|f| @fibers << f.to_foorth_fiber}
    rescue NoMethodError
      error "F70: A bundle may only contain procedures, fibers, or bundles."
    end

    #Return this bundle as a fiber.
    def to_foorth_fiber
      self
    end

    #What is the status of this bundle?
    def status
      @fibers.empty? ? "dead" : "alive"
    end

    #how many fibers in this bundle?
    def length
      @fibers.length
    end

    #Let the fiber run for one step
    def step(vm)
      if @current < @fibers.length
        if @fibers[@current].step(vm)
          @current += 1
        else
          @fibers.delete_at(@current)
        end
      end

      @current = 0 unless @current < @fibers.length
      !@fibers.empty?
    end

    #Run the fiber bundle constantly until done.
    def run(vm)
      while step(vm); end
    end
  end

  # [a_bundle] .to_fiber [a_bundle] ; Bundles are compatible with fibers!
  XfOOrth_Bundle.create_shared_method('.to_fiber', TosSpec, [], &lambda {|vm|
    vm.push(self)
  })

  #[a_bundle] .to_bundle [a_bundle]; Bundles are compatible with bundles too!
  XfOOrth_Bundle.create_shared_method('.to_bundle', TosSpec, [], &lambda{|vm|
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

  # [a_bundle] .status [a_string]; Does the bundle still have fibers in it?
  XfOOrth_Bundle.create_shared_method('.status', TosSpec, [], &lambda {|vm|
    vm.push(status)
  })

  # [a_bundle] .length [a_count]; How many fibers does the bundle have?
  XfOOrth_Bundle.create_shared_method('.length', TosSpec, [], &lambda {|vm|
    vm.push(self.length)
  })

end
