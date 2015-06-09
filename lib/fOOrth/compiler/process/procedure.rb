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
      buffer = open_proc_literal

      while (token = get_token)
        dbg_puts token.to_s
        code = token.code

        if (token.has_tag?(:immediate)) && (!@force)
          @context.recvr.instance_exec(self, &eval("lambda {|vm| #{code} }"))
        else
          @buffer << code
          @force = false
        end

      end

      buffer << close_proc_literal
    end



    def open_proc_literal(token)
      suspend_execute_mode("", :procedure)
      
      context.create_local_method('v', [:macro],
        &lambda {|vm| vm << "vm.push(vloop); "} )

      context.create_local_method('x', [:immediate],
        &lambda {|vm| vm << "vm.push(xloop); "} )

      context.create_local_method('}', [:immediate],
        &lambda {|vm| vm.resume_execute_mode('}; ', [:each_block]) })
      
      'vm.push(lambda {|vm, vloop=nil, xloop=nil| '
    end



    def close_proc_literal(token)
      resume_execute_mode("", [:procedure])
      '}); '
    end

  end
end
