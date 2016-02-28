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

  #[an_array_of_procs_fibers_or_bundles] .to_bundle [a_bundle]
  Array.create_shared_method('.to_bundle', TosSpec, [], &lambda{|vm|
    vm.push(XfOOrth_Bundle.new(self))
  })

  #[a_proc] .to_bundle [a_bundle]
  Proc.create_shared_method('.to_bundle', TosSpec, [], &lambda{|vm|
    vm.push(XfOOrth_Bundle.new(self))
  })

  #[a_bundle] .run []; Run the bundle until all of its fibers are done.
  XfOOrth_Bundle.create_shared_method('.run', TosSpec, [], &lambda{|vm|
    run(vm)
  })

end
