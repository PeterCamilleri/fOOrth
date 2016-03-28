# coding: utf-8

#* compiler/parser/get_string.rb - Extract string literals from code source.
module XfOOrth

  #* compiler/parser/get_string.rb - Extract string literals from code source.
  class Parser

    #Get the balance of a string from the source code source.
    def get_string
      vm = Thread.current[:vm]
      vm.quotes, done, result = 1, false, ''

      begin
        next_char = @source.get

        if next_char == "\\"
          break if process_backslash(result)
        elsif next_char == '"' || @source.eoln?
          vm.quotes, done = 0, true
        elsif next_char >= ' '
          result << next_char
        end
      end until done

      result
    end

    #Process a backlash character found with a string in the source text.
    #<br>Endemic Code Smells
    #* :reek:TooManyStatements
    def process_backslash(buffer)
      next_char = @source.get

      if next_char == ' ' && @source.eoln?
        next_char = skip_white_space_or_to_eoln
        return true if ['"', ' '].include?(next_char)
      elsif next_char == 'n'
        next_char = "\n"
      elsif next_char == 'x'
        next_char = process_8_bit
      elsif next_char == 'u'
        next_char = process_16_bit
      elsif next_char != "\\" && next_char != '"'
        error "F10: Invalid string literal value: '\\#{next_char}'"
      end

      buffer << next_char
      false
    end

    #Process an 8 bit hex character constant.
    def process_8_bit
      hex = process_hex_character + process_hex_character
      eval("\"\\x#{hex}\"")
    end

    #Process a 16 bit hex character constant.
    def process_16_bit
      hex = process_hex_character + process_hex_character +
            process_hex_character + process_hex_character
      eval("\"\\u#{hex}\"")
    end

    #Get a hex character from the input stream.
    def process_hex_character
      next_char = @source.get
      error "F10: Invalid hex character: '#{next_char}'" unless /\h/ =~ next_char

      next_char
    end
  end
end
