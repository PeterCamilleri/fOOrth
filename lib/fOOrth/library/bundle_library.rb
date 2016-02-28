# coding: utf-8

#* library/bundle_library.rb - The fOOrth Bundle class library.
module XfOOrth

  #Define the Bundle class.
  Object.create_foorth_subclass('Bundle').new_class

  #The fOOrth Bundle class. A bundle contains multiple fibers.
  class XfOOrth_Bundle

    #Build up the fiber instance
    def initialize(fibers=[])
      @fibers = fibers.in_array
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

end
