# coding: utf-8

#* compiler/parser/special.rb - Parse source code in special quoted mode.
module XfOOrth

  #* compiler/parser/special.rb - Parse source code in special quoted mode.
  class Parser

    #Get the next forth word and any embedded string data. This is used to
    #support the quoted compiler mode.
    #<br>Returns:
    #* A string with the next non-comment language element or nil if none
    #  could be found.
    #<br>Endemic Code Smells
    #  :reek:TooManyStatements
    def get_word_or_string
      return nil unless (word = get_word)

      if word[-1] == '"'
        vm = Thread.current[:vm]
        vm.quotes, skip, done = 1, false, false

        until done
          return nil unless (next_char = @source.get)
          word << next_char

          if skip
            skip = false
          elsif next_char == '"'
            vm.quotes, done = 0, true
          else
            skip = (next_char == '\\')
          end
        end
      end

      word
    end

  end

end
