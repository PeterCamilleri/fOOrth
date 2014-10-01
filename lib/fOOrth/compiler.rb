# coding: utf-8

require_relative 'compiler/console'
require_relative 'compiler/string_source'
require_relative 'compiler/file_source'
require_relative 'compiler/parser'
require_relative 'compiler/token'
require_relative 'compiler/modes'
require_relative 'compiler/process'

#* compiler.rb - The compiler portion of the fOOrth language system.
module XfOOrth

  #* compiler.rb - The compiler service of the virtual machine.
  class VirtualMachine

    #The current system console object. Gets the current console object
    #only creating one if somebody asks for one.
    #<br>Note
    #* This is to be the sole occurrence of @_private_console
    def console
      @_private_console ||= Console.new
    end

    #The current compiler code text source.
    attr_reader :source

    #The current compiler parser.
    attr_reader :parser

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
      @force  = false
    end

    #Execute code from the interactive console.
    def process_console
      #Work in progress.
      #Rubbish code for now.
      @level = 1

      console.flush

      until (next_char = console.get) == 'q'
        print next_char
        puts if console.eoln?
      end

      raise SilentExit
    end

    #Execute a string of code.
    def process_string(str)
      process(StringSource.new(str))
    end

    #Execute a file of code.
    def process_file(name)
      process(FileSource.new(name))
    end

  end

end
