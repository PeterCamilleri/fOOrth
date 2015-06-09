# coding: utf-8

#* compiler/process/generate.rb - Generate the Ruby object code.
module XfOOrth

  #* compiler/process/generate.rb - Generate the Ruby object code.
  class VirtualMachine

    #Finally generate some code!
    #<br>Parameters:
    #* token - The token to receive the generated code.
    #* word  - The text of the word.
    def generate_code(token, word)
      if (spec = @context.map(word))
        token.add(spec.builds, spec.tags)
      elsif (value = word.to_foorth_n)
        token.add("vm.push(#{value.foorth_embed}); ", [:numeric])
      else
        error "F10: ?#{word}?"
      end
    end

  end
end
