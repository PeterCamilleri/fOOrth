# coding: utf-8

#* compiler/process/procedure.rb - Get an embedded procedure literal.
module XfOOrth

  #* compiler/process/procedure.rb - Get an embedded procedure literal.
  class VirtualMachine

    private

    #Process optional string parameters.
    #<br>Parameters:
    #* token - The token to receive the generated code.
    #* word  - The text of the word.
    def procedure_parms(token, word)
      if word.end_with?('{{')
        token.add(get_procedure_literal, [:procedure])
      end
    end

    #Extract a procedure literal from the source code.
    def get_procedure_literal
      save, @buffer  = @buffer, ""
      open_procedure_literal

      begin
        token = get_procedure_token
        due_token(token)
      end until token.has_tag?(:end)

      close_procedure_literal
      (_, @buffer = @buffer, save)[0]
    end

    #The procedure used for procedure instance values
    PROC_VAL = lambda {|vm|
      context = vm.context.get_context_by_ctrl(:procedure)
      val_name = vm.parser.get_word()

      unless /^@[a-z][a-z0-9_]*$/ =~ val_name
        error "F10: Invalid val name #{val_name}"
      end

      val_symbol = XfOOrth::SymbolMap.add_entry(val_name)
      vm << "#{'@'+(val_symbol.to_s)} = vm.pop; "
      vm << "self.create_exclusive_method(#{val_name.inspect}, InstanceVarSpec, []); "

      context.create_local_method(val_name, LocalSpec, [:immediate], &lambda {|nvm|
        nvm << "vm.push(#{'@'+(val_symbol.to_s)}); "
      })
    }

    #The procedure used for procedure instance variables
    PROC_VAR = lambda {|vm|
      context = vm.context.get_context_by_ctrl(:procedure)
      var_name = vm.parser.get_word()

      unless /^@[a-z][a-z0-9_]*$/ =~ var_name
        error "F10: Invalid val name #{var_name}"
      end

      var_symbol = XfOOrth::SymbolMap.add_entry(var_name)
      vm << "#{'@'+(var_symbol.to_s)} = [vm.pop]; "
      vm << "self.create_exclusive_method(#{var_name.inspect}, InstanceVarSpec, []); "

      context.create_local_method(var_name, LocalSpec, [:immediate], &lambda {|nvm|
        nvm << "vm.push(#{'@'+(var_symbol.to_s)}); "
      })
    }

    #Handle the opening of a procedure literal.
    def open_procedure_literal
      suspend_execute_mode("vm.push(lambda {|vm, val=nil, idx=nil| ", :procedure)

      #Support for the standard procedure parameters.
      context.create_local_method('v',  MacroSpec, [:macro, "vm.push(val); "])
      context.create_local_method('x',  MacroSpec, [:macro, "vm.push(idx); "])

      #Support for local data.
      context.create_local_method('var:', LocalSpec, [:immediate], &Local_Var_Action)
      context.create_local_method('val:', LocalSpec, [:immediate], &Local_Val_Action)

      #Support for procedure instance data.
      context.create_local_method('var@:', LocalSpec, [:immediate], &PROC_VAR)
      context.create_local_method('val@:', LocalSpec, [:immediate], &PROC_VAL)

      context.create_local_method('}}', MacroSpec, [:macro, :end,     "}); "])
    end

    #Handle the closing of a procedure literal.
    def close_procedure_literal
      unnest_mode(nil, [:procedure])
    end

    #Get a token for the procedure literal.
    def get_procedure_token
      error "F12: Error, Invalid nesting." unless (token = get_token)
      token
    end

  end
end
