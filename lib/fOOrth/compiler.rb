# coding: utf-8

#* compiler.rb - The compiler portion of the fOOrth language system.
module XfOOrth

  #* compiler.rb - The compiler service of the virtual machine.
  class VirtualMachine

    #A stub for now.
    def compiler_reset
      @mode = :interperet
      @level = 0
      @quotes = 0
    end

  end

end
