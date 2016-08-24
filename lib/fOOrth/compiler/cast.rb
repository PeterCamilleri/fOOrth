# coding: utf-8

#* compiler/cast.rb - Support for casting methods to alternate routings.
module XfOOrth

  #* compiler/cast.rb - Support for casting methods to alternate routings.
  class VirtualMachine

    #Set the method cast.
    def set_cast(spec)
      error "F12: Multiple methods casts detected." if @cast
      @cast = spec
    end

    #Clear the method cast
    def clear_cast
      @cast = nil
    end

    #Verify the method cast
    def verify_cast(allowed)
      if @cast && !allowed.include?(@cast)
        fail "F13: Cast of #{@cast.class} not allowed."
      end
    end

    #Make sure there are no dangling casts.
    def verify_casts_cleared
      error "F12: Dangling methods casts detected." if @cast
    end

    #Get the method cast and clear it.
    def get_cast
      @cast
    end

  end

end