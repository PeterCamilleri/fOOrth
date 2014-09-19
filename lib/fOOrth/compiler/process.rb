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
      loop do
        return nil unless (word = parser.get_word)

        if word == '('
          parser.skip_over_comment
        elsif word == '//'
          parser.skip_to_eoln
        else
          break
        end
      end

      #Process optional string parameters.
      if word[-1] == '"'
        token_buffer = "vm.push(#{parser.get_string.embedd}); "
      else
        token_buffer = ''
      end

      #Finally, generate some code!
      tag = :none
      unless word == '"'

        #Try to map the word to a symbol.
        head = word[0]
        sym = SymbolMap.map(word) || head == '~' && SymbolMap.map('.' + word[1..-1])

        if sym
          if head == '.'
            token_buffer << "vm.pop.#{sym}(vm); "
          elsif head == '~'
            token_buffer << "self.#{sym}(vm); "
          else
            token_buffer << "vm.#{sym}(vm); "
          end
        elsif (value = word.to_foorth_n)
          token_buffer = "vm.push(#{value.embedd}); "
        else
          abort("?#{word}?")
        end
      end

      #Generate the Token structure result.
      Token.new(token_buffer, tag)
    end

  end

end
