# coding: utf-8

#* process.rb - Process source code from a code source.
module XfOOrth

  #* process.rb - Process source code from a code source.
  class VirtualMachine

    #A buffer used to hold generated object code.
    attr_reader :process_buffer

    #Process the source code provided by the source parameter.
    #<br>Parameters:
    #* source - A source object. Typically a Console, StringSource or FileSource.
    def process(source)

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
      token << "vm.push(#{parser.get_string.embedd}); " if word[-1] == '"'
    end

    #Finally generate some code!
    #<br>Parameters:
    #* token - The token to receive the generated code.
    #* word  - The text of the word.
    def generate_code(token, word)
      unless word == '"'
        #This is all rubbish!!!

        entry = SymbolMap.map(word) || word[0] == '~' && SymbolMap.map('.' + word[1..-1])

        if entry
          self.send(entry[1], token, entry[0], word)
        elsif (value = word.to_foorth_n)
          token << "vm.push(#{value.embedd}); "
        else
          abort("?#{word}?")
        end
      end
    end
  end
end