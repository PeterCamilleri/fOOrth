# coding: utf-8

require_relative 'compiler/console'
require_relative 'compiler/string_source'
require_relative 'compiler/file_source'
require_relative 'compiler/parser'
require_relative 'compiler/token'
require_relative 'compiler/modes'
require_relative 'compiler/word_specs'
require_relative 'compiler/context'
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

    #The current execution/compile context.
    attr_accessor :context

    #The level of lexical nesting.
    attr_reader :level

    #The level of quote nesting.
    attr_reader :quotes

    #Return the compiler to a known state.
    def compiler_reset
      @mode   = :Execute  #deprecated!
      @level  = 0
      @quotes = 0
      @buffer = nil
      @force  = false
      @context = Context.new(nil, class: VirtualMachine, mode: :Execute)
    end

    #Execute code from the interactive console.
    def process_console
      process(console)
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
