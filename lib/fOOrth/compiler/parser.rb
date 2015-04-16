# coding: utf-8

#* compiler/parser.rb - Parse source code from a code source.
module XfOOrth

  #* parser.rb - Parse source code from a code source.
  class Parser

    #The source of the text to be parsed.
    attr_reader :source

    #Initialize this parser.
    #<br>Parameters
    #* source - The source of the text to be parsed.
    def initialize(source)
      @source = source
    end

    #Get the next forth word and any embedded string data.
    #<br>Returns:
    #* A string with the next non-comment language element or nil if none
    #  could be found.
    def get_word_or_string
      return nil unless (word = get_word)

      if word[-1] == '"'
        skip = done = false

        until done
          return nil unless (next_char = @source.get)
          word << next_char

          if skip
            skip = false
          elsif next_char == '"'
            done = true
          else
            skip = (next_char == '\\')
          end
        end
      end

      word
    end

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

    #Skip over any white space.
    #<br>Returns:
    #* The first non-white space character or nil if none were found.
    def skip_white_space
      begin
        return nil unless (next_char = @source.get)
      end while next_char <= ' '

      next_char
    end

    #Get the balance of a string from the source code source.
    def get_string
      done, result = false, ''

      begin
        next_char = @source.get

        if next_char == "\\"
          result << process_backslash
        elsif next_char == '"'
          done = true
        elsif @source.eoln?
          done = true
        elsif next_char >= ' '
          result << next_char
        end
      end until done

      result
    end

    #Process a backlash character found with a string in the source text.
    def process_backslash
      next_char = @source.get

      if next_char == ' ' && @source.eoln?
        next_char = skip_white_space_or_to_eoln
      elsif next_char == 'n'
        next_char = "\n"
      elsif next_char == 'x'
        next_char = process_8_bit
      elsif next_char == 'u'
        next_char = process_16_bit
      elsif next_char != "\\" && next_char != '"'
        error "F10: Invalid string literal value: '\\#{next_char}'"
      end

      next_char
    end

    #Process an 8 bit hex character constant.
    def process_8_bit
      hex = process_hex_character +
            process_hex_character

      eval("\"\\x#{hex}\"")
    end

    #Process a 16 bit hex character constant.
    def process_16_bit
      hex = process_hex_character +
            process_hex_character +
            process_hex_character +
            process_hex_character

      eval("\"\\u#{hex}\"")
    end

    #Get a hex character from the input stream.
    def process_hex_character
      next_char = @source.get

      unless "0123456789ABCDEFabcdef".include?(next_char)
        error "F10: Invalid hex character: '#{next_char}'"
      end

      next_char
    end

    #Skip over a portion of the source text until end of line detected.
    #<br>Returns:
    #* true
    def skip_to_eoln
      @source.get until @source.eoln?
      true
    end

    #Skip over a portion of the source text until a ')' detected.
    #<br>Returns:
    #* true
    #<br>Note:
    #* Raises an XfOOrthError exception on an unterminated comment.
    def skip_over_comment
      until @source.eoln?
        return true if @source.get == ')'
      end

      error "F10: Unbalanced comment detected."
    end

    #Skip till a non-white space or an end of line
    def skip_white_space_or_to_eoln
      while (next_char = @source.get)
        return next_char if (next_char > ' ') || @source.eoln?
      end
    end

  end

end
