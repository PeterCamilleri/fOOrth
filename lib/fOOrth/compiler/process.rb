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
      #Get a non-comment word.
      return nil unless (word = parser.get_word)

      token = Token.new
      string_parms(token, word)
      generate_code(token, word)
      token
    end

    #Process optional string parameters.
    def string_parms(token, word)
      token << "vm.push(#{parser.get_string.embedd}); " if word[-1]
    end

    #Finally generate some code! This method is rubbish!
    def generate_code(token, word)
      unless word == '"'

        #Try to map the word to a symbol.
        head = word[0]
        sym = SymbolMap.map(word) || head == '~' && SymbolMap.map('.' + word[1..-1])

        if sym
          if head == '.'
            token << "vm.pop.#{sym}(vm); "
          elsif head == '~'
            token << "self.#{sym}(vm); "
          else
            token << "vm.#{sym}(vm); "
          end
        elsif (value = word.to_foorth_n)
          token << "vm.push(#{value.embedd}); "
        else
          abort("?#{word}?")
        end
      end
    end

  end

end
