# coding: utf-8

#* compiler/process/procedure.rb - Get an embedded procedure literal.
module XfOOrth

  #* compiler/process/procedure.rb - Get an embedded procedure literal.
  class VirtualMachine

    #Process optional string parameters.
    #<br>Parameters:
    #* token - The token to receive the generated code.
    #* word  - The text of the word.
    def procedure_parms(token, word)
      if word[-1] == '{'
        token.add(get_procedure, [:procedure])
      end
    end

    #Extract a procedure literal from the source code.
    def get_procedure
      save = @buffer
      @buffer = buffer = open_proc_literal

      begin
        unless (token = get_token)
          error "F12: Error, Invalid control/structure nesting."
        end

        dbg_puts token.to_s
        code = token.code

        if (token.has_tag?(:immediate)) && (!@force)
          @context.recvr.instance_exec(self, &eval("lambda {|vm| #{code} }"))
        else
          buffer << code
          @force = false
        end

      end until token.has_tag?(:end)

      @buffer = save
      close_proc_literal
      buffer
    end

    #Handle the opening of a procedure literal.
    def open_proc_literal
      suspend_execute_mode("", :procedure)
      context.create_local_method('v', MacroSpec, [:macro, "vm.push(vloop); "])
      context.create_local_method('x', MacroSpec, [:macro, "vm.push(xloop); "])
      context.create_local_method('}', MacroSpec, [:macro, :end, '}); '])
      dbg_puts code = 'vm.push(lambda {|vm, vloop=nil, xloop=nil| '
      code
    end

    #Handle the closing of a procedure literal.
    def close_proc_literal
      resume_execute_mode("", [:procedure])
    end

  end
end
