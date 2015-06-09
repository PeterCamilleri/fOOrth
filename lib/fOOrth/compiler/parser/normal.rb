# coding: utf-8

#* compiler/parser/normal.rb - Parse source code when not in quote mode.
module XfOOrth

  #* compiler/parser/normal.rb - Parse source code when not in quote mode.
  class Parser

    #Get the next forth word from the source code source. This method
    #recognizes and skips over comments in the source code.
    #<br>Returns:
    #* A string with the next non-comment language element or nil if none
    #  could be found.
    def get_word
      loop do
        return nil unless (word = get_word_raw)

        if word == '('
          skip_over_comment
        elsif word == '//'
          skip_to_eoln
        else
          return word
        end
      end
    end

    #Get the next forth word from the source code source. Recognizes, but
    #does not process comments in the source code.
    #<br>Returns:
    #* A string with the next language element or nil if none could be found.
    def get_word_raw
      #Skip white space.
      return nil unless (next_char = skip_white_space)

      #Gather the word token.
      word = ''

      begin
        word << next_char

        #Check for the three special cases.
        break if ['(', '//'].include?(word) || (next_char == '"')

        next_char = @source.get
      end while next_char && next_char > ' '

      word
    end

  end

end
