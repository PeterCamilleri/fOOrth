# coding: utf-8

#* compiler/process/string.rb - Get an embedded string literal.
module XfOOrth

  #* compiler/process/string.rb - Get an embedded string literal.
  class VirtualMachine

    #Process optional string parameters.
    #<br>Parameters:
    #* token - The token to receive the generated code.
    #* word  - The text of the word.
    def string_parms(token, word)
      if word[-1] == '"'
        token.add("vm.push(#{parser.get_string.foorth_embed}); ")
      end
    end

  end
end
