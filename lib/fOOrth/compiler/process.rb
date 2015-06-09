# coding: utf-8

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

    #Get the next token structure from the source code or nil if none
    #can be found.
    #<br>Returns
    #* A Token structure or nil.
    def get_token
      return nil unless (word = parser.get_word)

      token = Token.new
      string_parms(token, word)
      generate_code(token, word)
      token
    end

    #Process optional string parameters.
    #<br>Parameters:
    #* token - The token to receive the generated code.
    #* word  - The text of the word.
    def string_parms(token, word)
      token.add("vm.push(#{parser.get_string.foorth_embed}); ") if word[-1] == '"'
    end

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
