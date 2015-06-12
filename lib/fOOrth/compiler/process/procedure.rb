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
      if word.end_with?('{{')
        token.add(get_procedure, [:procedure])
      end
    end

    #Extract a procedure literal from the source code.
    def get_procedure
      save, @buffer  = @buffer, ""
      open_procedure_literal

      begin
        token = get_procedure_token
        process_procedure_token(token)
      end until token.has_tag?(:end)

      close_procedure_literal
      (result, @buffer = @buffer, save)[0]
    end

    #Handle the opening of a procedure literal.
    def open_procedure_literal
      suspend_execute_mode("vm.push(lambda {|vm, val=nil, idx=nil| ", :procedure)
      context.create_local_method('v',  MacroSpec, [:macro, "vm.push(val); "])
      context.create_local_method('x',  MacroSpec, [:macro, "vm.push(idx); "])
      context.create_local_method('}}', MacroSpec, [:macro, :end,     "}); "])
    end

    #Handle the closing of a procedure literal.
    def close_procedure_literal
      unnest_mode(nil, [:procedure])
    end

    #Get a token for the procedure literal.
    def get_procedure_token
      unless (token = get_token)
        error "F12: Error, Invalid control/structure nesting."
      end

      dbg_puts token.to_s
      token
    end

    #Process the next token in the procedure literal.
    def process_procedure_token(token)
      code = token.code

      if (token.has_tag?(:immediate)) && (!@force)
        @context.recvr.instance_exec(self, &eval("lambda {|vm| #{code} }"))
      else
        @buffer << code
        @force = false
      end
    end

  end
end
