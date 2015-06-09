# coding: utf-8

require_relative 'process/get_token'
require_relative 'process/string'
require_relative 'process/generate'

#* compiler/process.rb - Process source code from a code source.
module XfOOrth

  #* compiler/process.rb - Process source code from a code source.
  class VirtualMachine

    #Process the source code provided by the source parameter.
    #<br>Parameters:
    #* source - A source object. Typically a Console, StringSource or FileSource.
    def process(source)
      save, @parser, start_depth = @parser, Parser.new(source), @context.depth
      due_process
      @context.check_depth(start_depth)
      @parser = save
    end

    #The actual work of processing source code.
    def due_process
      while (token = get_token)
        dbg_puts token.to_s
        code = token.code

        if execute_mode || ((token.has_tag?(:immediate)) && (!@force))
          @context.recvr.instance_exec(self, &eval("lambda {|vm| #{code} }"))
        else
          @buffer << code
          @force = false
        end
      end
    end

  end
end
