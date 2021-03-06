# coding: utf-8

require_relative 'compiler/source'
require_relative 'compiler/parser'
require_relative 'compiler/token'
require_relative 'compiler/modes'
require_relative 'compiler/word_specs'
require_relative 'compiler/cast'
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

    #The current compiler parser.
    attr_reader :parser

    #The current execution/compile context.
    attr_reader :context

    #The level of quote nesting.
    attr_accessor :quotes

    #The level of comment nesting.
    attr_accessor :parens

    #Return the compiler to a known state.
    def compiler_reset
      @buffer = @parser = nil
      @quotes = @parens = 0
      clear_cast
      @context = Context.new(nil, vm: self, mode: :execute)
      self
    end

    #Append text to the compile buffer.
    def <<(text)
      dbg_puts "  Append=#{text.inspect}"
      @buffer << text
    rescue NoMethodError
      error "F14: The current mode does not allow code to be appended."
    end

    #Is the buffer valid?
    def buffer_valid?
      @buffer.is_a?(String)
    end

    #Execute code from the interactive console.
    def process_console
      process(console)
    ensure
      console.flush
    end

    #Execute a string of code.
    def process_string(str)
      process(StringSource.new(str))
    end

    #Execute a file of code.
    def process_file(name)
      source = FileSource.new(name)

      begin
        process(source)
      ensure
        source.close
      end
    end

  end

end
