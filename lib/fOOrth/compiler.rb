# coding: utf-8

require_relative 'compiler/read_point'
require_relative 'compiler/console'

#* compiler.rb - The compiler portion of the fOOrth language system.
module XfOOrth

  #* compiler.rb - The compiler service of the virtual machine.
  class VirtualMachine

    #Return the compiler to a known state.
    def compiler_reset
      @mode   = :Execute
      @level  = 0
      @quotes = 0
      @buffer = nil
      @force_compile = false
    end

    #Execute code from the interactive console.
    def execute_console
      #Work in progress!!!
    end

  end

end
