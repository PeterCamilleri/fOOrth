# coding: utf-8

require_relative 'compiler/console'
require_relative 'compiler/string_source'
require_relative 'compiler/file_source'

#* compiler.rb - The compiler portion of the fOOrth language system.
module XfOOrth

  #* compiler.rb - The compiler service of the virtual machine.
  class VirtualMachine

    #The current system console object.
    attr_reader :console

    #The current compiler code text source.
    attr_reader :source

    #The level of lexical nesting.
    attr_reader :level

    #The level of quote nesting.
    attr_reader :quotes

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
      #Work in progress.
      #Rubbish code for now.
      @level   = 1
      @console = Console.new

      until @console.get == 'q'
      end

      raise SilentExit
    end

    #Execute a string of code.
    def execute_string(str)
      #Work in progress!!!
    end

    #Execute a file of code.
    def execute_file(name)
      #Work in progress!!!
    end

  end

end
