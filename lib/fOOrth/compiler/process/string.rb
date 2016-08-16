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
      source = parser.source

      if word.end_with?('"')
        string_value = parser.get_string.foorth_embed

        if source.peek == '*'
          source.get
          token.add("vm.push(StringBuffer.new(#{string_value})); ")
        else
          token.add("vm.push(#{string_value}.freeze); ")
        end
      end
    end

  end
end
