# coding: utf-8

#* library/sync_bundle_library.rb - The fOOrth SyncBundle class library.
module XfOOrth

  #Define the SyncBundle class.
  XfOOrth_Bundle.create_foorth_subclass('SyncBundle').new_class

  #The fOOrth Synchronized Bundle class. A bundle contains multiple fibers.
  class XfOOrth_SyncBundle < XfOOrth_Bundle

    #Build up the synchronized bundle instance
    def initialize(fibers=[])
      @sync = Mutex.new
      super(fibers)
    end

    #Add the fibers to this bundle.
    def add_fibers(fibers)
      @sync.synchronize{super(fibers)}
    end

    #What is the status of this bundle?
    def status
      @sync.synchronize{super}
    end

    #how many fibers in this bundle?
    def length
      @sync.synchronize{super}
    end

    #Let the fiber run for one step
    def step(vm)
      @sync.synchronize{super(vm)}
    end

  end

  #[an_array_of_procs_fibers_or_bundles] .to_bundle [a_sync_bundle]
  Array.create_shared_method('.to_sync_bundle', TosSpec, [], &lambda{|vm|
    vm.push(XfOOrth_SyncBundle.new(self))
  })

  #[a_proc] .to_bundle [a_bundle]
  Proc.create_shared_method('.to_sync_bundle', TosSpec, [], &lambda{|vm|
    vm.push(XfOOrth_SyncBundle.new(self))
  })

end
